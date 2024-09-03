package com.okmindmap.service.helper;

import javax.servlet.ServletContext;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.okmindmap.service.PricingService;

public class PricingServiceHelper {
	public static PricingService getPricingService(ServletContext ctx) {
    	WebApplicationContext wac = WebApplicationContextUtils
                .getRequiredWebApplicationContext(ctx);
         return (PricingService) wac.getBean("pricingService");
    }
}
