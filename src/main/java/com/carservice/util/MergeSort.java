package com.carservice.util;

import com.carservice.model.Service;
import java.util.List;

public class MergeSort {
    public static void sortByCategory(List<Service> services) {
        mergeSort(services, 0, services.size() - 1, "category");
    }

    public static void sortByPrice(List<Service> services) {
        mergeSort(services, 0, services.size() - 1, "price");
    }

    private static void mergeSort(List<Service> services, int left, int right, String sortBy) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSort(services, left, mid, sortBy);
            mergeSort(services, mid + 1, right, sortBy);
            merge(services, left, mid, right, sortBy);
        }
    }

    private static void merge(List<Service> services, int left, int mid, int right, String sortBy) {
        int n1 = mid - left + 1;
        int n2 = right - mid;
        Service[] leftArray = new Service[n1];
        Service[] rightArray = new Service[n2];

        for (int i = 0; i < n1; i++) leftArray[i] = services.get(left + i);
        for (int j = 0; j < n2; j++) rightArray[j] = services.get(mid + 1 + j);

        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (sortBy.equals("category")) {
                if (leftArray[i].getCategory().compareTo(rightArray[j].getCategory()) <= 0) {
                    services.set(k, leftArray[i]);
                    i++;
                } else {
                    services.set(k, rightArray[j]);
                    j++;
                }
            } else {
                if (leftArray[i].getPrice() <= rightArray[j].getPrice()) {
                    services.set(k, leftArray[i]);
                    i++;
                } else {
                    services.set(k, rightArray[j]);
                    j++;
                }
            }
            k++;
        }

        while (i < n1) {
            services.set(k, leftArray[i]);
            i++;
            k++;
        }
        while (j < n2) {
            services.set(k, rightArray[j]);
            j++;
            k++;
        }
    }
}