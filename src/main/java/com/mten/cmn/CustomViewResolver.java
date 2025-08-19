package com.mten.cmn;

import org.springframework.core.Ordered;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.AbstractUrlBasedView;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.UrlBasedViewResolver;

import java.util.Locale;

public class CustomViewResolver extends UrlBasedViewResolver implements Ordered{
	@Override
	protected View loadView(String viewName,Locale locale) throws Exception{
		AbstractUrlBasedView view = buildView(viewName);
		System.out.println("view===>"+view);
		System.out.println("viewName===>"+viewName);
		View viewObj = (View)getApplicationContext().getAutowireCapableBeanFactory().initializeBean(view, viewName);
		if(viewObj instanceof JstlView){
			JstlView jv = (JstlView)viewObj;
			if(jv.getBeanName().indexOf("bylaw") != -1){
				return null;
			}
		}
		return viewObj;
	}
}
