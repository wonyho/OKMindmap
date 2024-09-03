package com.okmindmap.dao.mysql.spring;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.PreparedStatementCreator;

import com.okmindmap.dao.RepositoryDAO;
import com.okmindmap.dao.mysql.spring.mapper.RepositoryRowMapper;
import com.okmindmap.model.Repository;


public class SpringRepositoryDAO extends SpringDAOBase implements RepositoryDAO {

	@Override
	public int insertRepository(int mapid, int userid, String fileName, String path, String contentType, long fileSize) {
		String query = "INSERT INTO mm_repository (id, mapid, userid, filename, path, mime, filesize)"
				+ " VALUES (?, ?, ?, ?, ?, ?, ?)";
		int id = createNewID("mm_repository");

		getJdbcTemplate().update(
				query,
				new Object[] { id, mapid, userid, fileName, path, contentType, fileSize });

		return id;
	}
	
	@Override
	public Repository withdrawRepository(int repoid) {
		String sql =	"SELECT * " +
							"FROM mm_repository " +
							"WHERE id = ?";
		
		return (Repository)getJdbcTemplate().queryForObject(sql, new Object[] { repoid },
					new RepositoryRowMapper());
	}
	
	@Override
	public int totalUploadFileCapacity(int userid) {
		String sql = "SELECT COALESCE(SUM(filesize),0) as total FROM mm_repository WHERE userid= ?";
		return getJdbcTemplate().queryForObject(sql, 
				new Object[] { userid }, 
				Integer.class);
	}
	
	@Override
	public int removeRepository(int fileId) throws DataAccessException{
		String sql = "DELETE FROM mm_repository " +
				"WHERE id = ? ";

		return getJdbcTemplate().update(sql, new Object[]{fileId});
	}
	
	@Override
	public int removeRepositories(int mapId) throws DataAccessException{
		String sql = "DELETE FROM mm_repository " +
				"WHERE mapid = ? ";

		return getJdbcTemplate().update(sql, new Object[]{mapId});
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Repository> withdrawRepositories(int mapId) {
		String sql =	"SELECT * " +
				"FROM mm_repository " +
				"WHERE mapid = ?";

		return getJdbcTemplate().query(sql, new Object[] { mapId },
				new RepositoryRowMapper());
	}
}