package com.okmindmap.service;

import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.dao.DataAccessException;

import com.okmindmap.dao.PricingDAO;
import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Member;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;

public interface PricingService {
	
	public PricingDAO getPricingDAO();
	
	public int newTier(String name, String summary, int sortorder, boolean activated);
	public int insertTierMember(int tierid, int userid, boolean status, long expiry_date);
	
	public List<Tier> getAllTiers(int page, int pagelimit, String searchfield, String search, String sort, boolean isAsc);
	public List<Tier> getAllTiers(int userid, boolean status, Long expiry_date);
	public int countTiers(String searchfield, String search);
	public Tier getTier(int id);
	public List<TierAbility> getTierAbilities(int tierid);
	public List<Member> getTierMembers(int tierId, int page, int pagelimit,  String searchfield, String search, String sort, boolean isAsc);
	public int countTierMembers(int tierId, String searchfield, String search);
	public List<User> getNotTierMembers(int tierId, int page, int pagelimit,  String searchfield, String search, String sort, boolean isAsc);
	public int countNotTierMembers(int tierId, String searchfield, String search);
	public Member getMember(int id);
	public List<Member> getMemberList( int page, int pagelimit,  String searchfield, String search, String sort, boolean isAsc);
	public int countMemberList( String searchfield, String search);
	
	public int updateTier(Tier tier);
	public void updateTierAbility(int tierid, String policy_key, String value, boolean activated);
	public int updateMember(Member member);
	
	public int deleteTier(int tierid);
	public int deleteTierAbilities(int tierid);
	public int deleteMember(int id);
	public int deleteTierMemberByUserId(int userid);
	
	
	public JSONObject getCurrentTiersofUser(int userid) throws JSONException;
	public JSONObject getCurrentTiersofUser(int userid, String policy_key) throws JSONException;
	
	public Tier getTierGroup(int groupId);
	public int setTierGroup(int tierId, int groupId, boolean status, long expiry_date);
	public int deleteTierGroup(int groupId);
	
	public int getPolicyValue(int userid, String policy_key);
	public int setPolicyValue(int userid, String policy_key, int value);
	
	public int countUserMaps(int userId);
	public int countMoodleMaps(int userId);
	public int countRemixMaps(int userId);
	public int countIoTMaps(int userId);
}
