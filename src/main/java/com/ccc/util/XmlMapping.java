/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.util;

import java.io.File;
import java.util.Properties;

/**
 *
 * @author davidchang
 */
public class XmlMapping {
    private Properties properties;

    public XmlMapping(File file) {
        properties = new Properties();
        try{
            properties.loadFromXML(file.toURL().openStream());
        }catch(Exception e){
            
        }
    }
    public String LookupKey(String key, String... values){
        String message = properties.getProperty(key);
        if(message!=null){
        }else{
            return"";
        }
        return String.format(message, values);
    }
    
}
