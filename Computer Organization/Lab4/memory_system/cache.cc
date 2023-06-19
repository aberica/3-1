// ECE 430.322: Computer Organization
// Lab 4: Memory System Simulation

#include "cache.h"
#include <cstring>
#include <list>
#include <cassert>
#include <iostream>
#include <cmath>

cache_c::cache_c(std::string name, int level, int num_set, int assoc, int line_size, int latency)
    : cache_base_c(name, num_set, assoc, line_size) {

  // instantiate queues
  m_in_queue   = new queue_c();
  m_out_queue  = new queue_c();
  m_fill_queue = new queue_c();
  m_wb_queue   = new queue_c();
  m_ls_queue   = new queue_c();

  m_in_flight_wb_queue = new queue_c();

  m_id = 0;

  m_prev_i = nullptr;
  m_prev_d = nullptr;
  m_next = nullptr;
  m_memory = nullptr;

  m_latency = latency;
  m_level = level;

  // clock cycle
  m_cycle = 0;
  
  m_num_backinvals = 0;
  m_num_writebacks_backinval = 0;
}

cache_c::~cache_c() {
  delete m_in_queue;
  delete m_out_queue;
  delete m_fill_queue;
  delete m_wb_queue;
  delete m_in_flight_wb_queue;
}

/** 
 * Run a cycle for cache (DO NOT CHANGE)
 */
void cache_c::run_a_cycle() {
  // process the queues in the following order 
  // wb -> fill -> out -> in
  process_wb_queue();
  process_fill_queue();
  process_out_queue();
  process_in_queue();

  ++m_cycle;
}

void cache_c::configure_neighbors(cache_c* prev_i, cache_c* prev_d, cache_c* next, simple_mem_c* memory) {
  m_prev_i = prev_i;
  m_prev_d = prev_d;
  m_next = next;
  m_memory = memory;
}

/**
 *
 * [Cache Fill Flow]
 *
 * This function puts the memory request into fill_queue, so that the cache
 * line is to be filled or written-back.  When we fill or write-back the cache
 * line, it will take effect after the intrinsic cache latency.  Thus, this
 * function adjusts the ready cycle of the request; i.e., a new ready cycle
 * needs to be set for the request.
 *
 */
bool cache_c::fill(mem_req_s* req) {
  req->m_rdy_cycle = m_cycle + m_latency;
  return m_fill_queue->push(req);
}

/**
 * [Cache Access Flow]
 *
 * This function puts the memory request into in_queue.  When accessing the
 * cache, the outcome (e.g., hit/miss) will be known after the intrinsic cache
 * latency.  Thus, this function adjusts the ready cycle of the request; i.e.,
 * a new ready cycle needs to be set for the request .
 */
bool cache_c::access(mem_req_s* req) { 
  req->m_rdy_cycle = m_cycle + m_latency;
  return m_in_queue->push(req);
}

/** 
 * This function processes the input queue.
 * What this function does are
 * 1. iterates the requests in the queue
 * 2. performs a cache lookup in the "cache base" after the intrinsic access time
 * 3. on a cache hit, forward the request to the prev's fill_queue or the processor depending on the cache level.
 * 4. on a cache miss, put the current requests into out_queue
 */
void cache_c::process_in_queue() {
  // Iterate over the requests in the queue
  for (auto itr = m_in_queue->m_entry.begin(); itr != m_in_queue->m_entry.end(); ) {
    mem_req_s* req = *itr;
    // Check if the request is ready
    if (req->m_rdy_cycle <= m_cycle) {
      m_in_queue->pop(req);

      if (m_level == 1) {
        // check if there is a previous request which has same tag and index of addres
        bool pre_req_exist = false;
        auto in_flight_reqs = m_mm->get_in_flight_reqs();
        int line_size = cache_base_c::get_line_size();
        for (auto itr = in_flight_reqs.begin(); itr != in_flight_reqs.end(); ++itr) {
          auto prev_req = *itr;
          if (prev_req == req) break;

          if (prev_req->m_addr/line_size == req->m_addr/line_size && !prev_req->m_done) {
            m_ls_queue->push(req);
            pre_req_exist = true;
            break;
          }
        }
        if(pre_req_exist) continue;
        
        bool hit = cache_base_c::access(req->m_addr, req->m_type, 0); // lookup
        if (hit) {
          req->m_done = true;
          req->m_done_cycle = m_cycle;
        }
        else m_out_queue->push(req);
      }
      else if (m_level == 2) {
        // WB due to back-invalidation
        if (req->m_dirty && req->m_invalidate) {
          m_prev_d->m_in_flight_wb_queue->pop(req);
          m_out_queue->push(req);
          m_in_flight_wb_queue->push(req);
        }

        // WB due to eviction
        else if (req->m_dirty && !req->m_invalidate) {
          cache_base_c::access(req->m_addr, (req->m_type==1) ? 0:req->m_type, 3); // make dirty
          m_prev_d->m_in_flight_wb_queue->pop(req);
          delete req;
        }
        
        // Perform cache lookup and handle hit or miss
        else {
          bool hit = cache_base_c::access(req->m_addr, (req->m_type==1) ? 0:req->m_type, 0);  // lookup
          if (hit) {
            if(m_mm->m_config.get_mem_hierarchy() == static_cast<int>(Hierarchy::MULTI_LEVEL_SEPARATED) && req->m_type == 2)
              m_prev_i->fill(req);
            else  m_prev_d->fill(req);
          }
          else m_out_queue->push(req);
        }
      }
      

    }
    else itr++;
  }
}

/** 
 * This function processes the output queue.
 * The function pops the requests from out_queue and accesses the next-level's cache or main memory.
 * CURRENT: There is no limit on the number of requests we can process in a cycle.
 */
void cache_c::process_out_queue() {
  // Iterate over the requests in the queue
  for (auto itr = m_out_queue->m_entry.begin(); itr != m_out_queue->m_entry.end(); ) {
    mem_req_s* req = *itr;
    m_out_queue->pop(req);

    // SINGLE-LEVEL CACHE
    if (m_mm->m_config.get_mem_hierarchy() == static_cast<int>(Hierarchy::SINGLE_LEVEL)) {
      m_memory->access(req);
    }
    
    // MULTI-LEVEL CACHE
    else {
      if (m_level == 1) m_next->access(req);
      else if (m_level == 2) m_memory->access(req);
    }
    
  }
}


/** 
 * This function processes the fill queue.  The fill queue contains both the
 * data from the lower level and the dirty victim from the upper level.
 */
void cache_c::process_fill_queue() {
  // Iterate over the requests in the queue
  for (auto itr = m_fill_queue->m_entry.begin(); itr != m_fill_queue->m_entry.end(); ) {
    mem_req_s* req = *itr;
    // Check if the request is ready
    if (req->m_rdy_cycle <= m_cycle) {
      m_fill_queue->pop(req);

      if (m_level == 1) {
        // back-invalidation
        if (req->m_invalidate) {
          bool hit = cache_base_c::access(req->m_addr, req->m_type, 2);  // invalidate
          req->m_dirty = cache_c::get_victim_dirty();

          // WB due to back-invalidation
          if (hit) {
            m_num_backinvals++;
            if (req->m_dirty) {
              m_num_writebacks_backinval++;
              m_in_flight_wb_queue->push(req);
              m_wb_queue->push(req);
            }
            else delete req;
          }
          else delete req;
        }

        // Fill cache
        else {
          req->m_done = true;
          req->m_done_cycle = m_cycle;

          bool evicted = cache_base_c::access(req->m_addr, req->m_type, 1);  // cache fill
          bool evicted_dirty = cache_c::get_victim_dirty();
          addr_t evicted_addr = cache_c::get_victim_address();

          int line_size = cache_base_c::get_line_size();
          for (auto itr = m_ls_queue->m_entry.begin(); itr != m_ls_queue->m_entry.end(); ) {
            mem_req_s* ls_req = *itr;
            addr_t req_cache_block = req->m_addr/line_size;
            if (ls_req->m_addr/line_size == req_cache_block) {

              m_ls_queue->pop(ls_req);

              cache_base_c::access(ls_req->m_addr, ls_req->m_type, 0); // look up
              ls_req->m_done = true;
              ls_req->m_done_cycle = m_cycle;
            }
            else ++itr;
          }

          if (evicted && evicted_dirty) {
            mem_req_s* evicted_req = m_mm->create_mem_req(evicted_addr, 1);
            evicted_req->m_dirty = evicted_dirty; // =1
            m_in_flight_wb_queue->push(evicted_req);
            m_wb_queue->push(evicted_req);
          }
        }
      }
      else if (m_level == 2) {
        // Fill cache
        bool evicted = cache_base_c::access(req->m_addr, (req->m_type==1) ? 0:req->m_type, 1);
        bool evicted_dirty = cache_c::get_victim_dirty();
        addr_t evicted_addr = cache_c::get_victim_address();

        // WB
        if (evicted && evicted_dirty) {
          mem_req_s* evicted_req = m_mm->create_mem_req(evicted_addr, 1);
          evicted_req->m_dirty = evicted_dirty; // =1
          m_in_flight_wb_queue->push(evicted_req);
          m_wb_queue->push(evicted_req);
        }

        // back-invalidation
        if (evicted) {
          addr_t invalidate_addr = cache_c::get_victim_address();
          mem_req_s* invalidate_req = m_mm->create_mem_req(invalidate_addr, 1);
          invalidate_req->m_invalidate = true;
          m_prev_d->fill(invalidate_req);

          if (m_mm->m_config.get_mem_hierarchy() == static_cast<int>(Hierarchy::MULTI_LEVEL_SEPARATED)){
            mem_req_s* invalidate_req_i = m_mm->create_mem_req(invalidate_addr, 1);
            invalidate_req_i->m_invalidate = true;
            m_prev_i->fill(invalidate_req_i);
          }
        }

        if (m_mm->m_config.get_mem_hierarchy() == static_cast<int>(Hierarchy::MULTI_LEVEL_SEPARATED) && req->m_type == 2) m_prev_i->fill(req);
        else m_prev_d->fill(req);
      }
    }
    else itr++;
  }
}

/** 
 * This function processes the write-back queue.
 * The function basically moves the requests from wb_queue to out_queue.
 * CURRENT: There is no limit on the number of requests we can process in a cycle.
 */
void cache_c::process_wb_queue() {
  // Iterate over the requests in the queue
  for (auto itr = m_wb_queue->m_entry.begin(); itr != m_wb_queue->m_entry.end(); ) {
    auto req = *itr;
    m_wb_queue->pop(req);
    m_out_queue->push(req);
  }
}

/**
 * Print statistics (DO NOT CHANGE)
 */
void cache_c::print_stats() {
  cache_base_c::print_stats();
  std::cout << "number of back invalidations: " << m_num_backinvals << "\n";
  std::cout << "number of writebacks due to back invalidations: " << m_num_writebacks_backinval << "\n";
}
