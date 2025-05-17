package com.carservice.DSA;

import com.carservice.model.ServiceRecord;
import java.text.ParseException; //Used when string to data conversion fails
import java.text.SimpleDateFormat; //Help to format dates in a specific pattern
import java.util.Date;//To handle dates

public class SelectionSort {
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    // Sort service records by date
    public static void sortByDate(ServiceRecord[] records) { //parameter takes array of ServiceRecords
        int n = records.length;

        for (int i = 0; i < n - 1; i++) {
            // Find the minimum element in unsorted array
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (compareDates(records[j].getDate(), records[minIdx].getDate()) < 0) {
                    minIdx = j;
                }
            }

            //compare two dates and return:
            //negative if 1st date is earlier
            //positive if first date is later
            //zero if the dates are equal

            // Swap the found minimum element with the first element
            ServiceRecord temp = records[minIdx];
            records[minIdx] = records[i];
            records[i] = temp;
        }
    }

    // Helper method to compare dates
    private static int compareDates(String date1, String date2) {
        try {
            Date d1 = dateFormat.parse(date1);
            Date d2 = dateFormat.parse(date2);
            return d1.compareTo(d2);
        } catch (ParseException e) {
            System.err.println("Error parsing dates: " + e.getMessage());
            return 0;
        }
    }

    // Sort a ServiceRecordLinkedList by date
    public static void sortLinkedListByDate(ServiceRecordLinkedList list) {
        ServiceRecord[] records = list.toArray();
        sortByDate(records);
        
        // Clear the list and add sorted records back
        list.clear();
        for (ServiceRecord record : records) {
            list.add(record);
        }
    }
} 