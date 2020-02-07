global interface Collection {
    
    /** 
     * Adds the element to the collection.
     *
     * @param o The object to be added.
     * @return True if the element was successfully added.
     */
    Boolean add(final Object o);

    /**
     * Adds all of the elements in the specified collection to this collection.
     *
     * @param c Collection to be added.
     * @return True if the operation was successful.
     */
    Boolean addAll(final Collection c);

    /** Removes all elements from the collection. */
    void clear();

    /**
     * Returns true if the collection contains the specified element.
     * For Force.com Primitives.
     *
     * @param o The element we are looking for.
     * @return True if the collection contains the specified element.
     */
    Boolean contains(final Object o);

    /**
     * Returns true if the collection contains all elements of the specified collection.
     *
     * @param c Collection of elements we are looking for.
     * @return True if the collection contains all elements from the given collection.
     */
    Boolean containsAll(final Collection c);

    /**
     * Returns true if the collection has 0 elements in it.
     *
     * @return True if the collection has 0 elements in it.
     */
    Boolean isEmpty();

    /**
     * Removes the specified element from the collection.
     *
     * @param o The element to be removed.
     * @return True if the element was successfully removed.
     */
    Boolean remove(final Object o);

    /**
     * Gets an iterator for the collection.
     *
     * @return Iterator for the collection.
     */
    Iterator<Object> iterator();

    /**
     * Gets the number of element in the collection
     *
     * @return the number of elements in the collection
     */
    Integer size();
}