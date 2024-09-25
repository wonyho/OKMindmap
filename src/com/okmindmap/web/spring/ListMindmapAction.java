package com.okmindmap.web.spring;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.okmindmap.model.Map;
import com.okmindmap.model.User;
import com.okmindmap.model.UserConfigData;
import com.okmindmap.model.share.Share;
import com.okmindmap.service.GroupService;
import com.okmindmap.service.MindmapService;
import com.okmindmap.service.ShareService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

public class ListMindmapAction extends BaseAction {

	private MindmapService mindmapService;
	private ShareService shareService;
	private GroupService groupService;

	public void setMindmapService(MindmapService mindmapService) {
		this.mindmapService = mindmapService;
	}
	public void setShareService(ShareService shareService) {
		this.shareService = shareService;
	}
	public void setGroupService(GroupService groupService) {
		this.groupService = groupService;
	}
	
	@Override
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		User user = getUser(request);
		data.put("user", user);
		
		String userAgent = request.getHeader("user-agent");
		int page = ServletRequestUtils.getIntParameter(request, "page", 1);
		int sharetype = ServletRequestUtils.getIntParameter(request, "sharetype", 1);
		
		int pagelimit = ServletRequestUtils.getIntParameter(request, "pagelimit", 25);
		String search = ServletRequestUtils.getStringParameter(request, "search");
		String searchfield = ServletRequestUtils.getStringParameter(request, "searchfield");
		String sort = ServletRequestUtils.getStringParameter(request, "sort", "created");
		boolean isAsc = ServletRequestUtils.getBooleanParameter(request, "isAsc", false);
		// param으로 넘어온 값으로 맵 선택
		// param : user, myshares, 
		String mapType = ServletRequestUtils.getStringParameter(request, "maptype");
		if(mapType == null){
			mapType = user == null || user.getUsername().equals("guest")?"public":"user";
		}
		data.put("sort", sort);
		data.put("mapType", mapType);
		data.put("isAsc", isAsc);
		data.put("sharetype", sharetype);
		data.put("searchfield", searchfield);
		data.put("search", search);
		
		// Mobile 식별을 위한 값
		boolean isMobile = false;
		if(userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPod") != -1){
			data.put("mobile", "iPhone");
			isMobile = true;
		}else if(userAgent.indexOf("iPad") != -1){
			data.put("mobile", "iPad");
			isMobile = true;
		}else if(userAgent.indexOf("Android") != -1){
			data.put("mobile", "Android");
			isMobile = true;
		}
				
		int totalMaps =  0;
		List<Map> rMaps = null;
		if(mapType.equals("user")){		// 사용자 맵			
			if(!user.getUsername().equals("guest")) {
//				if(isMobile){
//					List<Map> maps = mindmapService.getUserMaps(user.getId());
//					data.put("maps", maps);
//				} else {
					List<Map> maps = mindmapService.getUserMaps(user.getId(), page, pagelimit, searchfield, search, sort, isAsc);
					totalMaps = mindmapService.countUserMaps(user.getId(),searchfield, search);
					data.put("maps", maps);
					data.put("pages", pages(totalMaps, pagelimit));
					
					
//					csedung add RecentMaps 2020.07.28
					rMaps = this.getUserRecentMaps(user.getId());		
					data.put("rmaps", rMaps);
//				}
			}			
		}
		else if(mapType.equals("myshares")){	// 나에게 공개된 맵
//			if(isMobile){
//				List<Share> shares = mindmapService.getMyShares(user.getId());
//				data.put("maps", shares);
//			} else {
				List<Share> shares = mindmapService.getMyShares(user.getId(), page, pagelimit, searchfield, search, sort, isAsc);
				totalMaps =  mindmapService.countMyShares(user.getId(),searchfield, search);
				data.put("maps", shares);
				data.put("pages", pages(totalMaps, pagelimit));
//			}
		}
		else if(mapType.equals("public")){	// 전체 공개된 맵
//			if(isMobile){
//				List<Map> maps = mindmapService.getPublicMaps(1);
//				data.put("maps", maps);
//			} else {
				List<Map> maps = mindmapService.getPublicMaps(sharetype, page, pagelimit, searchfield, search, sort, isAsc);
				totalMaps = mindmapService.countPublicMaps(sharetype, searchfield,search);
				data.put("maps", maps);
				data.put("pages", pages(totalMaps, pagelimit));	
//			}
		}
		//2011.6. 9 공유맵보이는 것이 전체공개에서 개인에게 공개된 맵으로, guest 맵은 전체 공개맵으로 변경이 되면서 기존의 공유맵과 guest 맵은 삭제 됨
		//혼란을 줄이기 위해 share => myshare, guest => public 으로 수정하여 사용함
		/*else if(mapType.equals("shares")){	// 공유된 맵
			if(userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPod") != -1){
				List<Share> shares = shareService.getShares(user.getId(), 0, 0, null, null);
				data.put("maps", shares);
			}
			else if(userAgent.indexOf("iPad") != -1){
				List<Share> shares = shareService.getShares(user.getId(), 0, 0, null, null);
				data.put("maps", shares);
			}
			else{
				List<Share> shares = shareService.getShares(user.getId(), page, pagelimit, search, "map");
				totalMaps =  shareService.countShares(user.getId(), search);
				data.put("maps", shares);
				data.put("pages", pages(totalMaps, pagelimit));
			}
		}
		//사용하지 않음
		else if(mapType.equals("guest")){	// 공개된 맵
			if(userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPod") != -1){
				List<Map> maps = mindmapService.getGuestMaps(page, pagelimit, searchfield, search, sort, isAsc);
				data.put("maps", maps);
			}
			else if(userAgent.indexOf("iPad") != -1){
				List<Map> maps = mindmapService.getGuestMaps(page, pagelimit, searchfield, search, sort, isAsc);
				data.put("maps", maps);
			}
			else{
				List<Map> maps = mindmapService.getGuestMaps(page, pagelimit, searchfield, search, sort, isAsc);
				totalMaps = mindmapService.countGuestMaps(searchfield,search);
				data.put("maps", maps);
				data.put("pages", pages(totalMaps, pagelimit));
				
			}
		}*/
		data.put("totalMaps", totalMaps);
		data.put("page", page);		
		data.put("pagelimit", pagelimit);		
		data.put("plPageRange", 15 );	 // 페이지출력 범위
		
		int tempA = ((page-1)*pagelimit);

		data.put("startnum", (totalMaps-tempA));
		
		
		String dataType = request.getParameter("dataType");
		if("json".equals(dataType)) {
			data.remove("user");
			data.remove("rmaps");
			JSONArray json = JSONArray.fromObject(data);
			response.setContentType("application/json");
			OutputStream out = response.getOutputStream();
			out.write(json.toString().getBytes("UTF-8"));
			out.close();
			return null;
		}
		
		
//		if(isMobile){
//			return new ModelAndView("list-m", "data", data);
//		} else {
			return new ModelAndView("list", "data", data);
//		}
		
	}

	// page 갯수 계산 
	private int pages(int total, int pagelimit) {
		int extra = total % pagelimit;
        
        if ( extra > 0 ){           
            return (total - extra )/pagelimit + 1;
        } else {
            return total/pagelimit;
        }
	}
	
//	csedung add RecentMaps 2020.07.28
	private List<Map> getUserRecentMaps(int uid) throws Exception {
		List<Map> maps = new ArrayList<Map>();
		List<UserConfigData> configData = this.userService.getUserConfigData(uid);
		String save = "";
		for(UserConfigData d : configData) {
			if(Objects.equals(d.getFieldname(),"user.rMaps")) {
				save = d.getData();
				break;
			}
		}
		String[] mList = save.split(" ");
		for(String ml : mList) {
			try {
				Map m = this.mindmapService.getMap(Integer.parseInt(ml));
				if(m != null) maps.add(m);
			}catch(Exception e) {}
		}
		return maps;		
	}
}
