package com.okmindmap.dao.mysql.spring;

import java.util.List;

import com.okmindmap.dao.LisDAO;
import com.okmindmap.dao.mysql.spring.mapper.LisGradeRowMapper;
import com.okmindmap.dao.mysql.spring.mapper.LisScoreRowMapper;
import com.okmindmap.model.LisGrade;

public class SpringLisDAO extends SpringDAOBase implements LisDAO {
	@Override
	public boolean insertLisGrade(LisGrade score) {
		int num = createNewID("mm_lis_grades");
		String query = " INSERT INTO `mm_lis_grades`(`id`, `lis_result_sourcedid`, `userid`, `mapid`, `nodeid`, `score`, `ts`) " +
				   " VALUES (?,?,?,?,?,?,?)";
		int result = getJdbcTemplate().update(query,new Object[]{
			num,
			score.getLisResultSourcedid(),
			score.getUserid(),
			score.getMapid(),
			score.getNodeid(),
			score.getScore(),
			System.currentTimeMillis()
			});
		return result > 0;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public LisGrade getLisGrade(int id) {
		String sql = "SELECT * FROM mm_lis_grades "
				+ "WHERE id = ? "
				+ "LIMIT 1 ";
		LisGrade lis = (LisGrade) getJdbcTemplate().queryForObject(sql, new Object[] { id }, new LisGradeRowMapper());
		return lis;
	}

	@SuppressWarnings("unchecked")
	@Override
	public LisGrade getLisGrade(int userid, int mapid, int nodeid) {
		String sql = "SELECT * FROM mm_lis_grades "
				+ "WHERE userid = ? AND mapid = ? AND nodeid = ? "
				+ "LIMIT 1 ";
		LisGrade lis = (LisGrade) getJdbcTemplate().queryForObject(sql, new Object[] { userid, mapid, nodeid }, new LisGradeRowMapper());
		return lis;
	}
	
	public double getScore(int userid, int mapid, int nodeid) {
		String sql = "SELECT IFNULL((SELECT IFNULL(score, '-1') as score "
				+ "FROM mm_lis_grades "
				+ "WHERE userid = "+userid+" AND mapid = "+mapid+" AND nodeid = "+nodeid+" "
				+ "ORDER BY ts DESC LIMIT 1), -1); ";
		Double value = (Double) getJdbcTemplate().queryForObject(sql, Double.class);
//		System.out.println("=================================:" + value);
		return value.doubleValue();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<LisGrade> getMaxListScore(int mapid, int nodeid){
		String sql = "SELECT sc.id, sc.userid, u.username, u.firstname, u.lastname, sc.mapid, sc.nodeid, sc.ts, "
				+ "MAX(score) as score "
				+ "FROM `mm_lis_grades` sc "
				+ "JOIN `mm_user` u ON sc.userid = u.id "
				+ "WHERE mapid = ? AND nodeid = ? "
				+ "GROUP BY sc.userid, sc.mapid, sc.nodeid "
				+ "ORDER BY u.firstname ";
		return getJdbcTemplate().query(sql, new Object[] { mapid, nodeid }, new LisScoreRowMapper());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<LisGrade> getLastListScore(int mapid, int nodeid){
		String sql = "SELECT sc.id, sc.userid, u.username, u.firstname, u.lastname, sc.mapid, sc.nodeid, sc.ts, "
				+ "SUBSTR(MAX(CONCAT(LPAD(sc.ts, 20, '0'), sc.score)), 21) AS score  "
				+ "FROM `mm_lis_grades` sc "
				+ "JOIN `mm_user` u ON sc.userid = u.id "
				+ "WHERE mapid = ? AND nodeid = ? "
				+ "GROUP BY sc.userid, sc.mapid, sc.nodeid "
				+ "ORDER BY u.firstname ";
		return getJdbcTemplate().query(sql, new Object[] { mapid, nodeid }, new LisScoreRowMapper());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<LisGrade> getAverageListScore(int mapid, int nodeid){
		String sql = "SELECT sc.id, sc.userid, u.username, u.firstname, u.lastname, sc.mapid, sc.nodeid, sc.ts, "
				+ "AVG(score) as score "
				+ "FROM `mm_lis_grades` sc "
				+ "JOIN `mm_user` u ON sc.userid = u.id "
				+ "WHERE mapid = ? AND nodeid = ? "
				+ "GROUP BY sc.userid, sc.mapid, sc.nodeid "
				+ "ORDER BY u.firstname ";
		return getJdbcTemplate().query(sql, new Object[] { mapid, nodeid }, new LisScoreRowMapper());
	}

}
