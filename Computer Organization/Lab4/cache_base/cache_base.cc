// ECE 430.322: Computer Organization
// Lab 4: Memory System Simulation

/**
 *
 * This is the base cache structure that maintains and updates the tag store
 * depending on a cache hit or a cache miss. Note that the implementation here
 * will be used throughout Lab 4. 
 */

#include "cache_base.h"

#include <cmath>
#include <string>
#include <cassert>
#include <fstream>
#include <iostream>
#include <iomanip>

/**
 * This allocates an "assoc" number of cache entries per a set
 * @param assoc - number of cache entries in a set
 */
cache_set_c::cache_set_c(int assoc) {
  m_entry = new cache_entry_c[assoc];
  m_assoc = assoc;
}

// cache_set_c destructor
cache_set_c::~cache_set_c() {
  delete[] m_entry;
}

/**
 * This constructor initializes a cache structure based on the cache parameters.
 * @param name - cache name; use any name you want
 * @param num_sets - number of sets in a cache
 * @param assoc - number of cache entries in a set
 * @param line_size - cache block (line) size in bytes
 *
 * @note You do not have to modify this (other than for debugging purposes).
 */
cache_base_c::cache_base_c(std::string name, int num_sets, int assoc, int line_size) {
  m_name = name;
  m_num_sets = num_sets;
  m_line_size = line_size;
  victim_address = 0;
  victim_dirty = false;

  m_set = new cache_set_c *[m_num_sets];

  for (int ii = 0; ii < m_num_sets; ++ii) {
    m_set[ii] = new cache_set_c(assoc);

    // initialize tag/valid/dirty bits
    for (int jj = 0; jj < assoc; ++jj) {
      m_set[ii]->m_entry[jj].m_valid = false;
      m_set[ii]->m_entry[jj].m_dirty = false;
      m_set[ii]->m_entry[jj].m_tag   = 0;
    }
  }

  // initialize stats
  m_num_accesses = 0;
  m_num_hits = 0;
  m_num_misses = 0;
  m_num_writes = 0;
  m_num_writebacks = 0;
}

// cache_base_c destructor
cache_base_c::~cache_base_c() {
  for (int ii = 0; ii < m_num_sets; ++ii) { delete m_set[ii]; }
  delete[] m_set;
}

/** 
 * This function looks up in the cache for a memory reference.lru_itr
 * This needs to update all the necessary meta-data (e.g., tag/valid/dirty) 
 * and the cache statistics, depending on a cache hit or a miss.
 * @param address - memory address 
 * @param access_type - lookup (0), write (1), or instruction fetch (2)
 * @param function - lookup (0), fill (1), invalidate (2), or mark dirty (3)
 * @param return - function 에 따라 if hit (0), if evict (1), if hit (2), TRUE (3)
 */

bool cache_base_c::access(addr_t address, int access_type, int function) {
  ////////////////////////////////////////////////////////////////////
  // TODO: Write the code to implement this function
  ////////////////////////////////////////////////////////////////////

  unsigned int index = (address / m_line_size) % m_num_sets;
  addr_t tag = (address / m_line_size) / m_num_sets;

  // Lookup cache. Return true if hit, false if miss.
  if (function == 0) {
    m_num_accesses++;

    // Look for the tag in the cache set
    for (int jj = 0; jj < m_set[index]->m_assoc; ++jj) {
      if (!m_set[index]->m_entry[jj].m_valid || m_set[index]->m_entry[jj].m_tag != tag) continue;

      // Cache hit
      
      m_num_hits++;

      // For write access, mark the cache line as dirty
      if (access_type == 1) {
        m_set[index]->m_entry[jj].m_dirty = true;
        m_num_writes++;
      }

      // Update the LRU state
      for (auto itr = m_set[index]->m_lru.begin(); itr != m_set[index]->m_lru.end(); ++itr) {
        if (*itr == jj) {
          m_set[index]->m_lru.erase(itr);
          break;
        }
      }
      m_set[index]->m_lru.push_back(jj);
      
      return true;
    }

    // Cache miss
    m_num_misses++;
    return false;
  }

  // Cache fill. Find an empty cache entry or evict the LRU entry. Return true if evict, false if no evict.
  else if (function == 1) {
    victim_dirty = false;

    // Find an empty cache entry
    for (int jj = 0; jj < m_set[index]->m_assoc; ++jj) {
      if (m_set[index]->m_entry[jj].m_valid == false) {

        // Cache fill with no eviction.
        m_set[index]->m_entry[jj].m_tag = tag;
        m_set[index]->m_entry[jj].m_valid = true;
        if (access_type == 1) {
          m_set[index]->m_entry[jj].m_dirty = true;
          m_num_writes++;
        }
        else m_set[index]->m_entry[jj].m_dirty = false;

        // Update the LRU state
        m_set[index]->m_lru.push_back(jj);

        return false;
      }
    }

    // Cache fill wtih eviction

    // Evict the LRU entry
    unsigned int jj = m_set[index]->m_lru.front();
    m_set[index]->m_lru.pop_front();
    m_set[index]->m_lru.push_back(jj);
    victim_address = (m_set[index]->m_entry[jj].m_tag * m_num_sets + index) * m_line_size;

    // If the LRU entry is dirty, write it back to memory
    if (m_set[index]->m_entry[jj].m_dirty) {
      m_num_writebacks++;
      victim_dirty = true;
    }

    // Insert the new cache entry
    m_set[index]->m_entry[jj].m_tag = tag;
    m_set[index]->m_entry[jj].m_valid = true;
    if (access_type == 1) {
      m_set[index]->m_entry[jj].m_dirty = true;
      m_num_writes++;
    }
    else m_set[index]->m_entry[jj].m_dirty = false;

    return true;
  }

  // Invalidate the cache entry if exist. Return true if hit, false if miss.
  else if (function == 2) {
    // Look for the tag in the cache set
    for (int jj = 0; jj < m_set[index]->m_assoc; ++jj) {
      if (!m_set[index]->m_entry[jj].m_valid || m_set[index]->m_entry[jj].m_tag != tag) continue;

      // Cache hit
      m_set[index]->m_entry[jj].m_valid = false;
      victim_dirty = m_set[index]->m_entry[jj].m_dirty;
      victim_address = (m_set[index]->m_entry[jj].m_tag * m_num_sets + index) * m_line_size;
      
      return true;
    }

    return false;
  }

  // Make block dirty if exist. Return just true
  else if (function == 3) {
    // Look for the tag in the cache set
    for (int jj = 0; jj < m_set[index]->m_assoc; ++jj) {
      if (!m_set[index]->m_entry[jj].m_valid || m_set[index]->m_entry[jj].m_tag != tag) continue;

      // Cache hit
      m_set[index]->m_entry[jj].m_dirty = true;
      m_num_writes++;
      
      break;
    }

    return true;
  }
  return true;
}


/**
 * Print statistics (DO NOT CHANGE)
 */
void cache_base_c::print_stats() {
  std::cout << "------------------------------" << "\n";
  std::cout << m_name << " Hit Rate: "          << (double)m_num_hits/m_num_accesses*100 << " % \n";
  std::cout << "------------------------------" << "\n";
  std::cout << "number of accesses: "    << m_num_accesses << "\n";
  std::cout << "number of hits: "        << m_num_hits << "\n";
  std::cout << "number of misses: "      << m_num_misses << "\n";
  std::cout << "number of writes: "      << m_num_writes << "\n";
  std::cout << "number of writebacks: "  << m_num_writebacks << "\n";
}


/**
 * Dump tag store (for debugging) 
 * Modify this if it does not dump from the MRU to LRU positions in your implementation.
 */
void cache_base_c::dump_tag_store(bool is_file) {
  auto write = [&](std::ostream &os) { 
    os << "------------------------------" << "\n";
    os << m_name << " Tag Store\n";
    os << "------------------------------" << "\n";

    for (int ii = 0; ii < m_num_sets; ii++) {
      for (int jj = 0; jj < m_set[0]->m_assoc; jj++) {
        os << "[" << (int)m_set[ii]->m_entry[jj].m_valid << ", ";
        os << (int)m_set[ii]->m_entry[jj].m_dirty << ", ";
        os << std::setw(10) << std::hex << m_set[ii]->m_entry[jj].m_tag << std::dec << "] ";
      }
      os << "\n";
    }
  };

  if (is_file) {
    std::ofstream ofs(m_name + ".dump");
    write(ofs);
  } else {
    write(std::cout);
  }
}


addr_t cache_base_c::get_victim_address() { return victim_address;}
bool cache_base_c::get_victim_dirty() { return victim_dirty; }
int cache_base_c::get_line_size() { return m_line_size; }