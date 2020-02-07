global abstract class AbstractQueue extends AbstractCollection implements Queue {

    /**
     * Constructor Initializes the Queue's type.
     *
     * @param t The type of the Queue.
     */
    protected AbstractQueue(final Type t) {
        super(t);
    }

    /**
     * Adds the element to the queue. If there is no room in the queue the element won't be added.
     * For Force.com primitives.
     *
     * @param o The element to be added.
     * @return True if the element was added to the queue.
     */
    global virtual Boolean offer(final Object o) {
        super.add(o);
        return true;
    }

    /**
     * Retrieves and removes the head of this queue, or returns null if this queue is empty.
     *
     * @return The head of the queue.
     */
    global abstract Object poll();

    /**
     * Retrieves, but does not remove, the head of this queue, or returns null if this queue is empty.
     *
     * @return The head of the queue.
     */
    global abstract Object peek();
    
    /**
     * Implementing to satisfy the interface.
     *
     * @return nothing
     * @throws NoSuchElementException if this queue is empty
     */
    global override Boolean remove(final Object o) {
        //throw new UnsupportedOperationException();
        return false;
    }

    /**
     * Removes all of the elements from this queue.
     * The queue will be empty after this call returns.
     *
     * This implementation repeatedly invokes poll until it
     * returns <tt>null</tt>.
     */
    global override void clear() {
        while (poll() != null);
    }


    /**
     * Implementing to satisfy the collection super interface.
     *
     * @throws UnsupportedOperationException
     */
    global override Boolean contains(final Object o) {
        throw new UnsupportedOperationException('Contains is not supported by queues.');
    }
}