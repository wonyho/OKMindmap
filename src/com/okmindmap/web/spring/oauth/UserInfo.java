package com.okmindmap.web.spring.oauth;

import com.google.gson.Gson;
import com.okmindmap.model.User;
import com.okmindmap.service.UserService;
import com.okmindmap.web.spring.BaseAction;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.ModelAndView;

public class UserInfo extends BaseAction
{

    public UserInfo()
    {
    }

    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
        throws Exception
    {
        String access_token = request.getParameter("access_token");
        User user = userService.getUserFromOkmmToken(access_token);
        String json = (new Gson()).toJson(user);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
        return null;
    }
}