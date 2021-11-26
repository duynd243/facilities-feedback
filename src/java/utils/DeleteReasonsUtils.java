package utils;

import java.util.HashMap;
import java.util.Map;

public class DeleteReasonsUtils {

    public static final Map deleteReasons = new HashMap<Integer, String>() {
        {
            put(1, "Wrong feedback information");
            put(2, "Duplicated feedback");
        }
    };

}