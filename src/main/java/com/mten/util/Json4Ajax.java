package com.mten.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.Iterator;
import java.util.List;


public class Json4Ajax {
	protected static Log log = LogFactory.getLog(Json4Ajax.class);
	/**
	 * 
	 * @param obj
	 * @param res
	 * @return
	 * @throws IOException
	 */
	public static String response(Object obj, HttpServletResponse res) throws IOException {
        res.setCharacterEncoding("UTF-8");
        
        String json = toJsonString(obj);
        //String json = (String) obj;
        BufferedReader reader = new BufferedReader(new StringReader(json));
        PrintWriter writer = null;
        try {
            writer = res.getWriter();

            String line = "";
            while ((line = reader.readLine()) != null) {
                writer.println(line);
                log.debug(line);
            }
            res.flushBuffer();
        } 
        catch (IOException e) {
            throw new IOException();
        } 
        finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    throw new IOException();
                }
            }

            if (writer != null)
                writer.close();
        }
        return null;
    }

    public static String toJsonString(Object obj) {
        String jsonString;

        if (obj instanceof List) {
            jsonString = genArrayJson((List) obj);
        } 
        else if (obj instanceof String) {
        	jsonString = (String) obj;
        }
        else {
            jsonString = genVoJson(obj);
        }

        return jsonString;
    }

    public static String genArrayJson(List list) {
        JSONSerializer serializer = new JSONSerializer();
        StringBuffer buff = new StringBuffer();
        buff.append("[");
        for (Iterator it = list.iterator(); it.hasNext();) {
            Object obj = it.next();
            buff.append(serializer.toJSON(obj).toString() + ","); 
        }
        String out = buff.toString();
        out = out.substring(0, out.length() - 1) + "]";
        return out;
    }

    private static String genVoJson(Object obj) {
        JSONSerializer serializer = new JSONSerializer();
        return serializer.toJSON(obj).toString(); 
    }
    
    public static void commonAjax(JSONObject result, HttpServletResponse response){
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			
			writer.println(result);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    
    public static void commonAjax(JSONArray result, HttpServletResponse response){
		try {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = null;
			writer = response.getWriter();
			
			writer.println(result);
			writer.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
