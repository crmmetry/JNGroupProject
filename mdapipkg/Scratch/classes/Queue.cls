global interface Queue extends Collection {

    /**
     * Adds the element to the queue. If there is no room in the queue the element won't be added.
     *
     * @param o The element to be added.
     * @return True if the element was added to the queue.
     */
    Boolean offer(final Object o);

    /**
     * Retrieves and removes the head of this queue, or returns null if this queue is empty.
     *
     * @return The head of the queue.
     */
    Object poll();

    /**
     * Retrieves, but does not remove, the head of this queue, or returns null if this queue is empty.
     *
     * @return The head of the queue.
     */
    Object peek();
}