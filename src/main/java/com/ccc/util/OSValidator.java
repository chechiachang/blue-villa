/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.util;

import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author davidchang
 */
public class OSValidator {

    private static final String OS = System.getProperty("os.name").toLowerCase();

    public static String getOS() {
        System.out.println(OS);
        
        if (isWindows()) {
            return "windows";
        } else if (isMac()) {
            return "mac";
        } else if (isUnix()) {
            return "unix";
        } else if (isSolaris()) {
            return "solaris";
        } else {
            return "unknown";
        }
    }

    private static boolean isWindows() {
        return (OS.contains("win"));
    }

    private static boolean isMac() {
        return (OS.contains("mac"));
    }

    private static boolean isUnix() {
        return (OS.contains("nix") || OS.contains("nux") || OS.contains("aix"));
    }

    private static boolean isSolaris() {
        return (OS.contains("sunos"));
    }
}
