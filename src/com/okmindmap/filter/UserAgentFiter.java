// ========================================================================
// Copyright (c) 2006-2009 Mort Bay Consulting Pty. Ltd.
// ------------------------------------------------------------------------
// All rights reserved. This program and the accompanying materials
// are made available under the terms of the Eclipse Public License v1.0
// and Apache License v2.0 which accompanies this distribution.
// The Eclipse Public License is available at 
// http://www.eclipse.org/legal/epl-v10.html
// The Apache License v2.0 is available at
// http://www.opensource.org/licenses/apache2.0.php
// You may elect to redistribute this code under either of these licenses. 
// ========================================================================

package com.okmindmap.filter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/* ------------------------------------------------------------ */
/** User Agent Filter.
 * <p>
 * This filter allows efficient matching of user agent strings for
 * downstream or extended filters to use for browser specific logic.
 * </p>
 * <p>
 * The filter is configured with the following init parameters:
 * <dl>
 * <dt>attribute</dt><dd>If set, then the request attribute of this name is set with the matched user agent string</dd>
 * <dt>cacheSize</dt><dd>The size of the user-agent cache, used to avoid reparsing of user agent strings. The entire cache is flushed
 * when this size is reached</dd>
 * <dt>userAgent</dt><dd>A regex {@link Pattern} to extract the essential elements of the user agent. 
 * The concatenation of matched pattern groups is used as the user agent name</dd>
 * <dl> 
 * An example value for pattern is <code>(?:Mozilla[^\(]*\(compatible;\s*+([^;]*);.*)|(?:.*?([^\s]+/[^\s]+).*)</code>. These two
 * pattern match the common compatibility user-agent strings and extract the real user agent, failing that, the first
 * element of the agent string is returned. 
 * 
 *
 */
public class UserAgentFiter implements Filter
{
    private Pattern _pattern;
    private Map _agentCache = new ConcurrentHashMap();
    private String _attribute;

    public void destroy()
    {
    }
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException
    {
        if (_attribute!=null && _pattern!=null)
        {       
            String ua=getUserAgent(request);
            boolean isMobile = false;
            if(ua != null){
            	if(ua.indexOf("iPhone") != -1 || ua.indexOf("iPod") != -1){
        			ua = "iPhone";
        			isMobile = true;
        		}else if(ua.indexOf("iPad") != -1){
        			ua = "iPad";
        			isMobile = true;
        		}else if(ua.indexOf("Android") != -1){
        			ua = "Android";
        			isMobile = true;
        		}else{
        			ua = null;
        		}
        		request.setAttribute("isMobile",isMobile);
                request.setAttribute(_attribute,ua);
            }
        }
        chain.doFilter(request,response);
    }

    /* ------------------------------------------------------------ */
    /* (non-Javadoc)
     * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
     */
    public void init(FilterConfig filterConfig) throws ServletException
    {
        _attribute=filterConfig.getInitParameter("attribute");
        
        String p=filterConfig.getInitParameter("userAgent");
        if (p!=null)
            _pattern=Pattern.compile(p);
    }

    /* ------------------------------------------------------------ */
    public String getUserAgent(ServletRequest request)
    {
        String ua=((HttpServletRequest)request).getHeader("user-agent");
        return getUserAgent(ua);
    }
    
    /* ------------------------------------------------------------ */
    /** Get UserAgent.
     * The configured agent patterns are used to match against the passed user agent string.
     * If any patterns match, the concatenation of pattern groups is returned as the user agent
     * string. Match results are cached.
     * @param ua A user agent string
     * @return The matched pattern groups or the original user agent string
     */
    public String getUserAgent(String ua)
    {
        if (ua==null)
            return null;
        
        String tag = (String)_agentCache.get(ua);
        

        if (tag==null)
        {
            Matcher matcher=_pattern.matcher(ua);
            if (matcher.matches())
            {
                if(matcher.groupCount()>0)
                {
                    for (int g=1;g<=matcher.groupCount();g++)
                    {
                        String group=matcher.group(g);
                        if (group!=null)
                            tag=tag==null?group:(tag+group);
                    }
                }
                else 
                    tag=matcher.group();
            }
            else
                tag=ua;
        }
        return tag;
    }
}