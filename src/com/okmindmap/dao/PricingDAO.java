package com.okmindmap.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Member;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;

public interface PricingDAO {
	
	public int insertTier (String name, String summary, int sortorder, boolean activated) throws DataAccessException;
	public int insertTierMember(int tierid, int userid, boolean status, long expiry_date) throws DataAccessException;
	
	public List<Tier> getAllTiers(int page, int pagelimit, String searchfield, String search, String sort, boolean isAsc) throws DataAccessException;
	public List<Tier> getAllTiers(int userid, boolean status, Long expiry_date) throws DataAccessException;
	public int countTiers(String searchfield, String search) throws DataAccessException;
	public Tier getTier(int id) throws DataAccessException;
	public List<TierAbility> getTierAbilities(int tierid) throws DataAccessException;
	public List<Member> getTierMembers(int tierId, int page, int pagelimit,  String searchfield, String search, String sort, boolean isAsc) throws DataAccessException;
	public int countTierMembers(int tierId, String searchfield, String search) throws DataAccessException;
	public List<User> getNotTierMembers(int tierId, int page, int pagelimit,  String searchfield, String search, String sort, boolean isAsc) throws DataAccessException;
	public int countNotTierMembers(int tierId, String searchfield, String search) throws DataAccessException;
	public Member getMember(int id) throws DataAccessException;
	public List<Member> getMemberList( int page, int pagelimit,  String searchfield, String search, String sort, boolean isAsc) throws DataAccessException;
	public int countMemberList( String searchfield, String search) throws DataAccessException;
	
	public int updateTier(Tier tier) throws DataAccessException;
	public void updateTierAbility(int tierid, String policy_key, String value, boolean activated) throws DataAccessException;
	public int updateMember(Member member) throws DataAccessException;
	
	public int deleteTier(int tierid) throws DataAccessException;
	public int deleteTierAbilities(int tierid) throws DataAccessException;
	public int deleteMember(int id) throws DataAccessException;
	public int deleteTierMemberByUserId(int userid) throws DataAccessException;
	
	public Tier getTierGroup(int groupId) throws DataAccessException;
	public int setTierGroup(int tierId, int groupId, boolean status, long expiry_date) throws DataAccessException;
	public int deleteTierGroup(int groupId) throws DataAccessException;
	
	public int getPolicyValue(int userid, String policy_key) throws DataAccessException;
	public int setPolicyValue(int userid, String policy_key, int value) throws DataAccessException;
	
	public int countUserMaps(int userId) throws DataAccessException;
	public int countMoodleMaps(int userId) throws DataAccessException;
	public int countRemixMaps(int userId) throws DataAccessException;
	public int countIoTMaps(int userId) throws DataAccessException;
	public int totalUploadFileCapacity(int userid);
}
