package com.okmindmap.dao.mysql.spring;

import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import com.okmindmap.dao.PricingDAO;
import com.okmindmap.dao.mysql.spring.mapper.UserRowMapper;
import com.okmindmap.dao.mysql.spring.mapper.pricing.MemberRowMapper;
import com.okmindmap.dao.mysql.spring.mapper.pricing.TierAbilityRowMapper;
import com.okmindmap.dao.mysql.spring.mapper.pricing.TierRowMapper;
import com.okmindmap.model.User;
import com.okmindmap.model.pricing.Member;
import com.okmindmap.model.pricing.Tier;
import com.okmindmap.model.pricing.TierAbility;

public class SpringPricingDAO extends SpringDAOBase implements PricingDAO {

	@Override
	public int insertTier(String name, String summary, int sortorder, boolean activated) throws DataAccessException {
		int num = createNewID("mm_tier");
		String query = " INSERT INTO mm_tier (name, summary, sortorder,activated, created,modified)" +
					   " VALUES (?,?,?,?,?,?)";
		
		getJdbcTemplate().update(query,new Object[]{
				name,
				summary,
				sortorder,
				activated,
				System.currentTimeMillis(),
				System.currentTimeMillis()
		});
		
		return num;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Tier> getAllTiers(int page, int pagelimit, String searchfield, String search, String sort,
			boolean isAsc) throws DataAccessException {
		String sql = "SELECT * FROM mm_tier ";
				
		ArrayList<Object> params = new ArrayList<Object>();
		
		if (search != null && search.trim().length() > 0) {
			sql += " WHERE " + searchfield +  " LIKE CONCAT('%', ?, '%')";
			params.add(search.trim());
		}
	
		if (sort == null) {
			sort = "id";
		}
		
		sql += " ORDER BY " + sort + (isAsc?" asc ": " desc ");
		
		if(pagelimit>0){
			sql += " LIMIT ? OFFSET ? ";
			params.add(pagelimit);
			params.add((page-1)*pagelimit);
		}
		
		return getJdbcTemplate().query(sql, params.toArray(),new TierRowMapper());
	}
	
	@Override
	public int countTiers(String searchfield, String search) throws DataAccessException {
		String sql = "SELECT COUNT(mm_tier.id) FROM mm_tier ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		if (search != null && search.trim().length() > 0) {
			sql += " WHERE " + searchfield +  " LIKE CONCAT('%', ?, '%')";
			params.add(search.trim());
		}
		
		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}

	@Override
	@SuppressWarnings("unchecked")
	public Tier getTier(int id) throws DataAccessException {
		String sql = "SELECT * FROM mm_tier WHERE id = ?";
		Tier tier = (Tier) getJdbcTemplate().queryForObject(sql, new Object[] { id }, new TierRowMapper());
		return tier;
	}

	
	@Override
	public int updateTier(Tier tier) throws DataAccessException {
		String query = "UPDATE mm_tier SET name = ?, summary = ?,  sortorder = ?, activated = ?, modified = ? WHERE id = ?";
		return getJdbcTemplate().update(query , new Object[] {
				tier.getName(),
				tier.getSummary(),
				tier.getSortorder(),
				tier.getActivated() ? 1 : 0,
				System.currentTimeMillis(),
				tier.getId()
		});
	}

	@Override
	public void updateTierAbility(int tierid, String policy_key, String value, boolean activated)
			throws DataAccessException {
		String sql ="SELECT COUNT(id) FROM mm_tier_ability WHERE tierid = ? AND policy_key = ?";
		int cnt = getJdbcTemplate().queryForObject(sql, new Object[] { tierid, policy_key }, Integer.class);
		if(cnt == 0) {
			sql = " INSERT INTO mm_tier_ability (tierid, policy_key, value, activated, created,modified)" +
					   " VALUES (?,?,?,?,?,?)";
		
			getJdbcTemplate().update(sql,new Object[]{
					tierid,
					policy_key,
					value,
					activated,
					System.currentTimeMillis(),
					System.currentTimeMillis()
			});
		} else {
			sql = "UPDATE mm_tier_ability SET value = ?, activated = ?,  modified = ? WHERE tierid = ? AND policy_key = ?";
			
			getJdbcTemplate().update(sql , new Object[] {
					value,
					activated,
					System.currentTimeMillis(),
					tierid,
					policy_key
			});
		}
	}

	@SuppressWarnings({ "unchecked" })
	@Override
	public List<TierAbility> getTierAbilities(int tierid) throws DataAccessException {
		String sql = "SELECT a.*, t.name,t.summary,t.activated as tier_activated FROM mm_tier_ability a LEFT JOIN mm_tier t ON a.tierid = t.id WHERE a.tierid = ?";
		
		return getJdbcTemplate().query(sql, new Object[] { tierid }, new TierAbilityRowMapper());
	}

	@Override
	public int deleteTier(int tierid) throws DataAccessException {
		getJdbcTemplate().update("DELETE FROM mm_tier_ability WHERE tierid = ?", new Object[] { tierid });
		getJdbcTemplate().update("DELETE FROM mm_tier_member WHERE tierid = ?", new Object[] { tierid });
		
		
		String sql = "DELETE FROM mm_tier WHERE id = ?";

		return getJdbcTemplate().update(sql, new Object[] { tierid });
	}

	@Override
	public int deleteTierAbilities(int tierid) throws DataAccessException {
		String sql = "DELETE FROM mm_tier_ability WHERE tierid = ?";

		return getJdbcTemplate().update(sql, new Object[] { tierid });
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Member> getTierMembers(int tierId, int page, int pagelimit, String searchfield, String search,
			String sort, boolean isAsc) throws DataAccessException {
		String sql = "SELECT m.*,t.name as tier_name,t.summary as tier_summary,t.activated as tier_activated,u.username,u.firstname,u.lastname,.u.email FROM mm_tier_member m LEFT JOIN mm_tier t  ON m.tierid = t.id LEFT JOIN mm_user u ON m.userid = u.id ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		sql += " WHERE m.tierid = ?";
		params.add(tierId);
		
		if (search != null && search.trim().length() > 0) {
			sql += " AND " + searchfield +  " LIKE CONCAT('%', ?, '%')";
			params.add(search.trim());
		}
	
		if (sort == null) {
			sort = "m.created";
			isAsc = false;
		}
		
		sql += " ORDER BY " + sort + (isAsc?" asc ": " desc ");
		
		if(pagelimit>0){
			sql += " LIMIT ? OFFSET ? ";
			params.add(pagelimit);
			params.add((page-1)*pagelimit);
		}
		
		return getJdbcTemplate().query(sql, params.toArray(),new MemberRowMapper());
	}

	@Override
	public int countTierMembers(int tierId, String searchfield, String search) throws DataAccessException {
		String sql = "SELECT COUNT(DISTINCT m.id) FROM mm_tier_member m LEFT JOIN mm_tier t  ON m.tierid = t.id LEFT JOIN mm_user u ON m.userid = u.id ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		if (search != null && search.trim().length() > 0) {
			sql += " WHERE " + searchfield +  " LIKE CONCAT('%', ?, '%')";
			params.add(search.trim());
		}
		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<User> getNotTierMembers(int tierId, int page, int pagelimit, String searchfield, String search,
			String sort, boolean isAsc) throws DataAccessException {
		String sql = "SELECT u.* FROM mm_user u LEFT JOIN mm_tier_member m  ON m.userid = u.id ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		sql += " WHERE  m.id IS NULL ";
		
		if (search != null && search.trim().length() > 0) {
			sql += " AND " + searchfield +  " LIKE CONCAT('%', ?, '%')";
			params.add(search.trim());
		}
	
		if (sort == null) {
			sort = "u.id";
			isAsc = false;
		}
		
		sql += " ORDER BY " + sort + (isAsc?" asc ": " desc ");
		
		if(pagelimit>0){
			sql += " LIMIT ? OFFSET ? ";
			params.add(pagelimit);
			params.add((page-1)*pagelimit);
		}
		
		return getJdbcTemplate().query(sql, params.toArray(),new UserRowMapper());
	}

	@Override
	public int countNotTierMembers(int tierId, String searchfield, String search) throws DataAccessException {
		String sql = "SELECT COUNT(DISTINCT u.id) FROM mm_user u LEFT JOIN mm_tier_member m  ON m.userid = u.id ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		sql += " WHERE  m.id IS NULL ";
		
		if (search != null && search.trim().length() > 0) {
			sql += " AND " + searchfield +  " LIKE CONCAT('%', ?, '%')";
			params.add(search.trim());
		}
		
		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}

	@Override
	public int insertTierMember(int tierid, int userid, boolean status, long expiry_date) throws DataAccessException {
		int num = createNewID("mm_tier_member");
		String query = " INSERT INTO mm_tier_member (tierid, userid, status, created, expiry_date)" +
					   " VALUES (?,?,?,?,?)";
		
		getJdbcTemplate().update(query,new Object[]{
				tierid,
				userid,
				status ? 1:0,
				System.currentTimeMillis(),
				expiry_date
		});
		
		return num;
	}

	@Override
	public Member getMember(int id) throws DataAccessException {
		String sql = "SELECT m.*,t.name as tier_name,t.summary as tier_summary,t.activated as tier_activated,u.username,u.firstname,u.lastname,.u.email FROM mm_tier_member m LEFT JOIN mm_tier t  ON m.tierid = t.id LEFT JOIN mm_user u ON m.userid = u.id WHERE m.id = ?";
		@SuppressWarnings("unchecked")
		Member member = (Member) getJdbcTemplate().queryForObject(sql, new Object[] { id }, new MemberRowMapper());
		return member;
	}

	@Override
	public int updateMember(Member member) throws DataAccessException {
		String query = "UPDATE mm_tier_member SET tierid = ?, userid = ?,  status = ?, expiry_date = ?, created = ? WHERE id = ?";
		return getJdbcTemplate().update(query , new Object[] {
				member.getTier().getId(),
				member.getUser().getId(),
				member.getStatus() ? 1:0,
				member.getExpiryDate(),
				member.getCreated(),
				member.getId()
		});
	}

	@Override
	public int deleteMember(int id) throws DataAccessException {
		String sql = "DELETE FROM mm_tier_member WHERE id = ?";

		return getJdbcTemplate().update(sql, new Object[] { id });
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Tier> getAllTiers(int userid, boolean status, Long expiry_date) throws DataAccessException {
		String sql = "SELECT t.* FROM mm_tier t LEFT JOIN mm_tier_member m ON m.tierid = t.id WHERE t.activated = 1 AND m.userid = ? AND m.status = ?";

		ArrayList<Object> params = new ArrayList<Object>();
		
		params.add(userid);
		params.add(status ? 1:0);
		
		if (expiry_date != null) {
			sql += " AND m.expiry_date >= ?";
			params.add(expiry_date);
		}
		
		return getJdbcTemplate().query(sql, params.toArray(), new TierRowMapper());
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Member> getMemberList(int page, int pagelimit, String searchfield, String search, String sort,
			boolean isAsc) throws DataAccessException {
		String sql = "SELECT u.id as userid,t.name as tier_name,t.summary as tier_summary,t.activated as tier_activated,u.username,u.firstname,u.lastname,.u.email, m.id,m.tierid, m.status, m.created, m.expiry_date "
				+ "FROM mm_user u "
				+ "LEFT JOIN mm_tier_member m ON m.userid = u.id "
				+ "LEFT JOIN mm_tier t  ON m.tierid = t.id ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		if (search != null && search.trim().length() > 0) {
			if("fullname".equals(searchfield)) {
				sql += " WHERE (u.firstname LIKE CONCAT('%', ?, '%') OR u.lastname LIKE CONCAT('%', ?, '%'))";
				params.add(search.trim());
				params.add(search.trim());
			} else {
				sql += " WHERE " + searchfield +  " LIKE CONCAT('%', ?, '%')";
				params.add(search.trim());
			}
		}
	
		if (sort == null) {
			sort = "u.id";
			isAsc = false;
		}
		
		sql += " ORDER BY " + sort + (isAsc?" asc ": " desc ");
		
		if(pagelimit>0){
			sql += " LIMIT ? OFFSET ? ";
			params.add(pagelimit);
			params.add((page-1)*pagelimit);
		}
		
		return getJdbcTemplate().query(sql, params.toArray(),new MemberRowMapper());
	}
	
	@Override
	public int countMemberList(String searchfield, String search) throws DataAccessException {
		String sql = "SELECT COUNT(u.id) "
				+ "FROM mm_user u "
				+ "LEFT JOIN mm_tier_member m ON m.userid = u.id "
				+ "LEFT JOIN mm_tier t  ON m.tierid = t.id ";
		
		ArrayList<Object> params = new ArrayList<Object>();
		
		if (search != null && search.trim().length() > 0) {
			if("fullname".equals(searchfield)) {
				sql += " WHERE (u.firstname LIKE CONCAT('%', ?, '%') OR u.lastname LIKE CONCAT('%', ?, '%'))";
				params.add(search.trim());
				params.add(search.trim());
			} else {
				sql += " WHERE " + searchfield +  " LIKE CONCAT('%', ?, '%')";
				params.add(search.trim());
			}
		}
		
		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}

	@Override
	public int deleteTierMemberByUserId(int userid) throws DataAccessException {
		return getJdbcTemplate().update("DELETE FROM mm_tier_member WHERE userid = ?", new Object[] { userid });
	}

	@SuppressWarnings("unchecked")
	@Override
	public Tier getTierGroup(int groupId) throws DataAccessException {
		try {
			String sql = "SELECT t.* FROM mm_tier as t JOIN mm_tier_group as g ON t.id = g.tierid WHERE g.groupid = ? limit 1";
			Tier tier = (Tier) getJdbcTemplate().queryForObject(sql, new Object[] { groupId }, new TierRowMapper());
			return tier;
		} catch(DataAccessException e) {
			//
		}
		return null;
	}

	@Override
	public int setTierGroup( int tierId, int groupId, boolean status, long expiry_date) throws DataAccessException {
		getJdbcTemplate().update("DELETE FROM mm_tier_group WHERE groupid = ?", new Object[] { groupId });
		
		int num = createNewID("mm_tier_group");
		String query = " INSERT INTO mm_tier_group (tierid, groupid, status, created, expiry_date)" +
					   " VALUES (?,?,?,?,?)";
		
		getJdbcTemplate().update(query,new Object[]{
				tierId,
				groupId,
				status,
				System.currentTimeMillis(),
				expiry_date
		});
		
		return num;
		
	}

	@Override
	public int deleteTierGroup(int groupId) throws DataAccessException {
		return getJdbcTemplate().update("DELETE FROM mm_tier_group WHERE groupid = ?", new Object[] { groupId });
	}

	@Override
	public int getPolicyValue(int userid, String policy_key) throws DataAccessException {
		if("map.create".equals(policy_key)) {
			return this.countUserMaps(userid);
		} else if("map.remix".equals(policy_key)) {
			return this.countRemixMaps(userid);
		} else if("moodle".equals(policy_key)) {
			return this.countMoodleMaps(userid);
		} else if("iot.add".equals(policy_key)) {
			return this.countIoTMaps(userid);
		} else if("capacity.limit".equals(policy_key)) {
			if(userid != 2) return this.totalUploadFileCapacity(userid) / 1048576;
			return 0;
		}
		
		String sql = "SELECT mm_tier_user_data.value FROM mm_tier_user_data WHERE userid = ? AND policy_key = ? limit 1";
		
		try {
			int value =  getJdbcTemplate().queryForObject(sql,  new Object[] { userid, policy_key }, Integer.class);
			return value;
		} catch(DataAccessException e) {}
		return 0;
	}

	@Override
	public int setPolicyValue(int userid, String policy_key, int value) throws DataAccessException {
		try {
			String sql = "SELECT mm_tier_user_data.id FROM mm_tier_user_data WHERE userid = ? AND policy_key = ? limit 1";
			int id =  getJdbcTemplate().queryForObject(sql,  new Object[] { userid, policy_key }, Integer.class);
			
			String query = "UPDATE mm_tier_user_data SET value = ? WHERE id = ?";
			return getJdbcTemplate().update(query , new Object[] { value, id });
		} catch(DataAccessException e) {
			int num = createNewID("mm_tier_user_data");
			String query = " INSERT INTO mm_tier_user_data (userid, policy_key, value)" +
						   " VALUES (?,?,?)";
			
			getJdbcTemplate().update(query,new Object[]{ userid, policy_key, value });
			return num;
		}
	}

	@Override
	public int countMoodleMaps(int userId) throws DataAccessException {
		String sql = "SELECT COUNT(m.id) AS count " + "FROM mm_map m "
				+ "LEFT JOIN mm_map_owner o ON m.id = o.mapid "
				+ "LEFT JOIN mm_node n ON m.id = n.map_id "
				+ "LEFT JOIN mm_attribute a ON n.id = a.node_id "
				+ "WHERE n.parent_id = 0 AND a.name = ? AND o.userid = ? ";

		ArrayList<Object> params = new ArrayList<Object>();
		params.add("moodleCourseId");
		params.add(userId);

		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}

	@Override
	public int countRemixMaps(int userId) throws DataAccessException {
		String sql = "SELECT COUNT(m.id) AS count " + "FROM mm_map m "
				+ "LEFT JOIN mm_map_owner o ON m.id = o.mapid "
				+ "LEFT JOIN mm_node n ON m.id = n.map_id "
				+ "LEFT JOIN mm_attribute a ON n.id = a.node_id "
				+ "WHERE n.parent_id = 0 AND a.name = ? AND o.userid = ? ";

		ArrayList<Object> params = new ArrayList<Object>();
		params.add("remixMap");
		params.add(userId);

		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}

	@Override
	public int countIoTMaps(int userId) throws DataAccessException {
		String sql = "SELECT COUNT(m.id) AS count " + "FROM mm_map m "
				+ "LEFT JOIN mm_map_owner o ON m.id = o.mapid "
				+ "LEFT JOIN mm_node n ON m.id = n.map_id "
				+ "LEFT JOIN mm_attribute a ON n.id = a.node_id "
				+ "WHERE a.name = ? AND o.userid = ? ";

		ArrayList<Object> params = new ArrayList<Object>();
		params.add("iot");
		params.add(userId);

		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}
	
	@Override
	public int totalUploadFileCapacity(int userid) {
		String sql = "SELECT COALESCE(SUM(filesize),0) as total FROM mm_repository WHERE userid= ?";
		return getJdbcTemplate().queryForObject(sql, 
				new Object[] { userid }, 
				Integer.class);
	}

	@Override
	public int countUserMaps(int userId) throws DataAccessException {
		String sql = "SELECT COUNT(m.id) AS count " + "FROM mm_map m "
				+ "JOIN mm_map_owner o ON m.id = o.mapid "
				+ "WHERE o.userid = ? ";

		ArrayList<Object> params = new ArrayList<Object>();
		params.add(userId);
		
		return getJdbcTemplate().queryForObject(sql, params.toArray(), Integer.class);
	}
}