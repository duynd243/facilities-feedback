/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

/**
 *
 * @author Duy
 */
public class PaginationUtils {
    public static final int ITEMS_PER_PAGE = 4;
    
    public static int isInteger(String s) {
        int num;
        try {
            num = Integer.parseInt(s);
        } catch (Exception e) {
            num = -1;
        }
        return num;
    }

    public static int getCurrentPage(String s, int numOfPages) {
        int page = isInteger(s);
        int currentPage = 1;
        if (page >= 1 && page <= numOfPages) {
            currentPage = page;
        } else if (page < 1) {
            currentPage = 1;
        } else if (page > numOfPages) {
            currentPage = numOfPages;
        }
        return currentPage;
    }
    
    public static int getNumOfPages(int numOfItems){
        return (int) Math.ceil(numOfItems / (double)ITEMS_PER_PAGE);
    }
    
    
    
}
