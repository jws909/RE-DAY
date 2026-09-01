package com.app.util;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;

public class DateUtil {
	
	public static String DateToDayOfWeek(String date) {
		
		if (date != null && date.length() >= 10) {                   
	        String dateOnly = date.substring(0, 10);                                      
	        LocalDate localDate = LocalDate.parse(dateOnly);                                                   
	        String dayOfWeek = localDate.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.KOREAN);    
	                                                                                                           
	        return dayOfWeek;                                                        
	    } 
		
		return null;
	}
}
