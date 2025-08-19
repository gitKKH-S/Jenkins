package com.mten.util;

import org.springframework.context.support.MessageSourceAccessor;

import java.util.Locale;

public class LocaleMessage {

    private static MessageSourceAccessor msAcc = null;
    
    public static void setMessageSourceAccessor(MessageSourceAccessor msAcc) {
        LocaleMessage.msAcc = msAcc;
    }
    
    public static String getMessage(String key) {
        return msAcc.getMessage(key, Locale.getDefault());
    }
    
    public static String getMessage(String key, Object[] objs) {
        return msAcc.getMessage(key, objs, Locale.getDefault());
    }
}