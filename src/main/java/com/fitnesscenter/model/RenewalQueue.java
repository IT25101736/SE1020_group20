package com.fitnesscenter.model;

import java.util.LinkedList;
import java.util.Queue;
import java.util.List;
import java.util.ArrayList;

public class RenewalQueue {

    // Queue data structure — FIFO (First In First Out)
    private Queue<RenewalRequest> queue;

    public RenewalQueue() {
        this.queue = new LinkedList<>();
    }

    // ENQUEUE — add request to back of queue
    public void enqueue(RenewalRequest request) {
        queue.offer(request);
    }

    // DEQUEUE — remove and return request from front of queue
    public RenewalRequest dequeue() {
        return queue.poll();
    }

    // PEEK — see front without removing
    public RenewalRequest peek() {
        return queue.peek();
    }

    // Check if empty
    public boolean isEmpty() {
        return queue.isEmpty();
    }

    // Size
    public int size() {
        return queue.size();
    }

    // Get all as list (for displaying in JSP)
    public List<RenewalRequest> toList() {
        return new ArrayList<>(queue);
    }

    // Load from list (when reading from file)
    public void loadFromList(List<RenewalRequest> requests) {
        queue.clear();
        for (RenewalRequest r : requests) {
            queue.offer(r);
        }
    }
}

