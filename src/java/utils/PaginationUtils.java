package utils;

/**
 *
 * @author Duy
 */
public class PaginationUtils {

    public static final int ITEMS_PER_FEEDBACK_PAGE = 4;
    public static final int ITEMS_PER_USER_PAGE = 5;

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

    public static int getNumOfFeedbackPages(int numOfItems) {
        return (int) Math.ceil(numOfItems / (double) ITEMS_PER_FEEDBACK_PAGE);
    }

    public static int getNumOfUserPages(int numOfItems) {
        return (int) Math.ceil(numOfItems / (double) ITEMS_PER_USER_PAGE);
    }

}