package com.okmindmap.service.impl;

import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.okmindmap.dao.PricingDAO;
import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Member;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;
import com.okmindmap.service.PricingService;

public class PricingServiceImpl implements PricingService {
	
	public PricingDAO pricingDAO;
		
	public void setPricingDAO(PricingDAO pricingDAO) {
		this.pricingDAO = pricingDAO;
	}

	@Override
	public PricingDAO getPricingDAO() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int newTier(String name, String summary, int sortorder, boolean activated) {
		return this.pricingDAO.insertTier(name, summary, sortorder, activated);
	}

	@Override
	public List<Tier> getAllTiers(int page, int pagelimit, String searchfield, String search, String sort,
			boolean isAsc) {
		return this.pricingDAO.getAllTiers(page, pagelimit, searchfield, search, sort, isAsc);
	}
	
	@Override
	public int countTiers(String searchfield, String search) {
		return this.pricingDAO.countTiers(searchfield, search);
	}

	@Override
	public Tier getTier(int id) {
		try {
			return this.pricingDAO.getTier(id);
		} catch (Exception e) {
			return null;
		}
	}

	@Override
	public int updateTier(Tier tier) {
		return this.pricingDAO.updateTier(tier);
	}

	@Override
	public void updateTierAbility(int tierid, String policy_key, String value, boolean activated) {
		this.pricingDAO.updateTierAbility(tierid, policy_key, value, activated);
	}

	@Override
	public List<TierAbility> getTierAbilities(int tierid) {
		return this.pricingDAO.getTierAbilities(tierid);
	}

	@Override
	public int deleteTier(int tierid) {
		return this.pricingDAO.deleteTier(tierid);
	}

	@Override
	public int deleteTierAbilities(int tierid) {
		return this.pricingDAO.deleteTierAbilities(tierid);
	}

	@Override
	public List<Member> getTierMembers(int tierId, int page, int pagelimit, String searchfield, String search,
			String sort, boolean isAsc) {
		return this.pricingDAO.getTierMembers(tierId, page, pagelimit, searchfield, search, sort, isAsc);
	}

	@Override
	public int countTierMembers(int tierId, String searchfield, String search) {
		return this.pricingDAO.countTierMembers(tierId, searchfield, search);
	}

	@Override
	public List<User> getNotTierMembers(int tierId, int page, int pagelimit, String searchfield, String search,
			String sort, boolean isAsc) {
		return this.pricingDAO.getNotTierMembers(tierId, page, pagelimit, searchfield, search, sort, isAsc);
	}

	@Override
	public int countNotTierMembers(int tierId, String searchfield, String search) {
		return this.pricingDAO.countNotTierMembers(tierId, searchfield, search);
	}

	@Override
	public int insertTierMember(int tierid, int userid, boolean status, long expiry_date) {
		return this.pricingDAO.insertTierMember(tierid, userid, status, expiry_date);
	}

	@Override
	public Member getMember(int id) {
		return this.pricingDAO.getMember(id);
	}

	@Override
	public int updateMember(Member member) {
		return this.pricingDAO.updateMember(member);
	}

	@Override
	public int deleteMember(int id) {
		return this.pricingDAO.deleteMember(id);
	}

	@Override
	public List<Tier> getAllTiers(int userid, boolean status, Long expiry_date) {
		return this.pricingDAO.getAllTiers(userid, status, expiry_date);
	}

	@Override
	public JSONObject getCurrentTiersofUser(int userid) throws JSONException {
		JSONObject policy = new JSONObject();
		
		List<Tier> tiers = this.pricingDAO.getAllTiers(userid, true, null);
		String tier_name = "";
		int tier_id = 0;
		if(tiers.size() > 0) {
			for(Tier tier : tiers) {
				tier_name = tier.getName();
				tier_id = tier.getId();
				List<TierAbility> functions = this.pricingDAO.getTierAbilities(tier.getId());
				for(TierAbility fn : functions) {
					if(fn.getActivated()) {
						JSONObject value = new JSONObject();
						value.put("value", fn.getValue());
						value.put("used", this.pricingDAO.getPolicyValue(userid, fn.getPolicyKey()));
						
						String key = fn.getPolicyKey().replace('.', '_');
						if(!policy.has(key)) {
							JSONArray arr = new JSONArray();
							if(!"".equals(fn.getValue())) {
								arr.put(value);
							}
							policy.put(key, arr);
						} else {
							JSONArray arr = (JSONArray) policy.get(key);
							if(!"".equals(fn.getValue())) {
								arr.put(value);
							}
							policy.put(key, arr);
						}
					}
				}
			}
		} else {
			Tier tier = this.pricingDAO.getTier(1);
			tier_name = tier.getName();
			tier_id = tier.getId();
			List<TierAbility> functions = this.pricingDAO.getTierAbilities(1); // tierid= 1; => Free tier 
			for(TierAbility fn : functions) {
				if(fn.getActivated()) {
					JSONObject value = new JSONObject();
					value.put("value", fn.getValue());
					value.put("used", this.pricingDAO.getPolicyValue(userid, fn.getPolicyKey()));
					
					String key = fn.getPolicyKey().replace('.', '_');
					if(!policy.has(key)) {
						JSONArray arr = new JSONArray();
						if(!"".equals(fn.getValue())) {
							arr.put(value);
						}
						policy.put(key, arr);
					} else {
						JSONArray arr = (JSONArray) policy.get(key);
						if(!"".equals(fn.getValue())) {
							arr.put(value);
						}
						policy.put(key, arr);
					}
				}
			}
		}
		
		policy.put("tier_name", tier_name);
		policy.put("tier_id", tier_id);
		
		return policy;
	}
	
	@Override
	public JSONObject getCurrentTiersofUser(int userid, String policy_key) throws JSONException {
		JSONObject policy = this.getCurrentTiersofUser(userid);
		if(policy.has(policy_key)) {
			JSONArray arr_policy =  (JSONArray) policy.get(policy_key);
			 if(arr_policy.length() > 0) return arr_policy.getJSONObject(0);
		}
		return null;
	}

	@Override
	public List<Member> getMemberList(int page, int pagelimit, String searchfield, String search, String sort,
			boolean isAsc) {
		return this.pricingDAO.getMemberList(page, pagelimit, searchfield, search, sort, isAsc);
	}

	@Override
	public int countMemberList(String searchfield, String search) {
		return this.pricingDAO.countMemberList(searchfield, search);
	}

	@Override
	public int deleteTierMemberByUserId(int userid) {
		return this.pricingDAO.deleteTierMemberByUserId(userid);
	}

	@Override
	public Tier getTierGroup(int groupId) {
		return  this.pricingDAO.getTierGroup(groupId);
	}

	@Override
	public int setTierGroup(int tierId, int groupId, boolean status, long expiry_date) {
		return this.pricingDAO.setTierGroup(tierId, groupId, status, expiry_date);
	}

	@Override
	public int deleteTierGroup(int groupId) {
		return this.pricingDAO.deleteTierGroup(groupId);
	}

	@Override
	public int getPolicyValue(int userid, String policy_key) {
		return this.pricingDAO.getPolicyValue(userid, policy_key);
	}

	@Override
	public int setPolicyValue(int userid, String policy_key, int value) {
		return this.pricingDAO.setPolicyValue(userid, policy_key, value);
	}

	@Override
	public int countMoodleMaps(int userId) {
		return this.pricingDAO.countMoodleMaps(userId);
	}

	@Override
	public int countRemixMaps(int userId) {
		return this.pricingDAO.countRemixMaps(userId);
	}

	@Override
	public int countIoTMaps(int userId) {
		return this.pricingDAO.countIoTMaps(userId);
	}

	@Override
	public int countUserMaps(int userId) {
		return this.countUserMaps(userId);
	}
}