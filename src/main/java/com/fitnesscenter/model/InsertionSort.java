
package com.fitnesscenter.model;

import java.util.List;

public class InsertionSort {

    // Insertion Sort algorithm — sorts members by renewal/expiry date
    // ascending order (oldest first)
    public static void sortByExpiryDate(List<Member> members) {
        int n = members.size();

        for (int i = 1; i < n; i++) {
            Member key = members.get(i);
            int j = i - 1;

            // Move elements that are greater than key one position ahead
            while (j >= 0 && compareDate(members.get(j).getExpiryDate(), key.getExpiryDate()) > 0) {
                members.set(j + 1, members.get(j));
                j--;
            }
            members.set(j + 1, key);
        }
    }

    // Compare two dates in format YYYY-MM-DD
    private static int compareDate(String date1, String date2) {
        if (date1 == null || date1.isEmpty()) return 1;
        if (date2 == null || date2.isEmpty()) return -1;
        return date1.compareTo(date2);
    }
}