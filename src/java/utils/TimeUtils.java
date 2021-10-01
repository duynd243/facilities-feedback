/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.StringTokenizer;

/**
 *
 * @author Duy
 */
public class TimeUtils {

    public static String currentTimeString() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
        LocalDateTime now = LocalDateTime.now();
        return dtf.format(now);
    }

    public static String renderedTime(String time) {
        StringTokenizer stk = new StringTokenizer(time);
        String day = stk.nextToken();
        String hour = stk.nextToken().substring(0, 8);
        StringTokenizer stk2 = new StringTokenizer(day, "-");
        String yyyy = stk2.nextToken();
        String mm = stk2.nextToken();
        String dd = stk2.nextToken();
        day = dd + "-" + mm + "-" + yyyy;
        time = hour + " | " + day;
        return time;
    }

}
