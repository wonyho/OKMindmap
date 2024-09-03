package com.okmindmap.dao.mysql.spring;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.ColumnMapRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapperResultSetExtractor;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.jdbc.support.KeyHolder;

import com.okmindmap.sync.LockObjectManager;

public class SpringDAOBase {
	protected JdbcTemplate jdbcTemplate;
//	protected NamedParameterJdbcTemplate namedParameterJdbcTemplate;
	protected DataSource dataSource;
	protected static String TABLE_SCHEMA = null;
	
	
	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public void setTableSchema(String schema) {
		SpringDAOBase.TABLE_SCHEMA =schema ;
	}
	
	protected JdbcTemplate getJdbcTemplate() {
		if(this.jdbcTemplate == null) {
			this.jdbcTemplate = new JdbcTemplate(getDataSource());
		}
		
		return this.jdbcTemplate;
	}
	
	protected int createNewID(String tableName) {
		if(SpringDAOBase.TABLE_SCHEMA == null) {
			try {
				SpringDAOBase.TABLE_SCHEMA = this.dataSource.getConnection().getCatalog();
			} catch (SQLException e) {
				SpringDAOBase.TABLE_SCHEMA = "okmindmap";
				
				e.printStackTrace();
			}
		}
		
		String query = "SELECT AUTO_INCREMENT" +
			" FROM information_schema.TABLES" +
			" WHERE TABLE_SCHEMA = '" + SpringDAOBase.TABLE_SCHEMA + "'" +
			" AND TABLE_NAME = ?";
		
		int id = -1;
		
		String key = "lock_create_table_id_" + tableName;
		Object lock = LockObjectManager.getInstance().lock(key);
		synchronized (lock) {
			id = getJdbcTemplate().queryForObject(query, new Object[]{tableName}, Integer.class);
		}
		LockObjectManager.getInstance().unlock(key);
		
		return id;
	}
	
	/**
	 * 
	 * @param psc
	 * @return int 새로 생성된 ID 값
	 */
//	protected int insert(PreparedStatementCreator psc) {
//		final KeyHolder holder = new GeneratedKeyHolder();
//	    getJdbcTemplate().execute(psc, new PreparedStatementCallback<Integer>() {
//			public Integer doInPreparedStatement(PreparedStatement ps) throws SQLException {
//				ps.execute();
//				List<Map<String, Object>> generatedKeys = holder.getKeyList();
//				generatedKeys.clear();
//				ResultSet keys = ps.getGeneratedKeys();
//				if (keys != null) {
//					try {
//						RowMapperResultSetExtractor<Map<String, Object>> rse =
//								new RowMapperResultSetExtractor<Map<String, Object>>(new ColumnMapRowMapper(), 1);
//						generatedKeys.addAll(rse.extractData(keys));
//					}
//					finally {
//						JdbcUtils.closeResultSet(keys);
//					}
//				}
//
//				return 1;
//			}
//		});
//	    
//	    return holder.getKey().intValue();
//	}
}
