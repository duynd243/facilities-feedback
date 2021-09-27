/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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

}