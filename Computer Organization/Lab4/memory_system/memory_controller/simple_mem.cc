#include "simple_mem.h"

simple_mem_c::simple_mem_c(const std::string& name, int level, uint32_t latency) {
    m_name = name;
    m_latency = latency;
    m_level = level;
    m_in_queue = new queue_c();
    m_out_queue = new queue_c();
    m_cycle = 0;
    m_prev = nullptr;
    m_in_flight_wb_queue = new queue_c();
}

simple_mem_c::~simple_mem_c() {
  delete m_in_queue;
  delete m_out_queue;
  delete m_in_flight_wb_queue;
}

void simple_mem_c::run_a_cycle() {
    process_out_queue();
    process_in_queue();

    ++m_cycle;
}

void simple_mem_c::configure_neighbors(cache_c* prev) {
    m_prev = prev;
}

bool simple_mem_c::access(mem_req_s* req) {
    req->m_rdy_cycle = m_cycle + m_latency;
    return m_in_queue->push(req);
}

void simple_mem_c::process_in_queue() {
    // Iterate over the requests in the queue
    for (auto itr = m_in_queue->m_entry.begin(); itr != m_in_queue->m_entry.end(); ) {
    auto req = *itr;
    // Check if the request is ready
    if (req->m_rdy_cycle <= m_cycle) {
        m_in_queue->pop(req);

        if (req->m_dirty) {
            m_prev->m_in_flight_wb_queue->pop(req);
            delete req;
        }
        else {
            m_out_queue->push(req);
        }
    }
    else itr++;
  }
}

void simple_mem_c::process_out_queue() {
    while(!m_out_queue->empty()) {
        auto req = m_out_queue->m_entry.front();
        m_out_queue->pop(req);
        
        if (m_prev != nullptr) m_prev->fill(req);
    }
}