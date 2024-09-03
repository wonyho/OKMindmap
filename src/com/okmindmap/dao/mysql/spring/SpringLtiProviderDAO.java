package com.okmindmap.dao.mysql.spring;

import java.util.List;

import com.okmindmap.dao.LtiProviderDAO;
import com.okmindmap.dao.mysql.spring.mapper.LtiProviderRowMapper;
import com.okmindmap.model.LtiProvider;

public class SpringLtiProviderDAO extends SpringDAOBase implements LtiProviderDAO {

	@Override
	public boolean insertLtiProvider(LtiProvider lti) {
		int num = createNewID("mm_lti_provider");
		String query = "INSERT INTO `mm_lti_provider`(`id`, `secret`, `resourseType`, `resourseAttrs`, `returnUrl`, `created`) "
				+ " VALUES (?,?,?,?,?,?)";
		int result = getJdbcTemplate().update(query, new Object[] { num, lti.getSecret(), lti.getResourseType(),
				lti.getResourseAttrs(), lti.getReturnUrl(), System.currentTimeMillis() });
		return result > 0;

	}

	@Override
	public boolean deleteLtiProvider(long id) {
		int num = createNewID("mm_lti_provider");
		String query = "DELETE FROM `mm_lti_provider` WHERE id = ? ";
		int result = getJdbcTemplate().update(query, new Object[] { id });
		return result > 0;

	}

	@Override
	public boolean deleteLtiProvider(String url) {
		int num = createNewID("mm_lti_provider");
		String query = "DELETE FROM `mm_lti_provider` WHERE returnUrl = ? ";
		int result = getJdbcTemplate().update(query, new Object[] { url });
		return result > 0;

	}

	@Override
	@SuppressWarnings("unchecked")
	public LtiProvider getLtiProvider(long id) {
		String sql = "SELECT * FROM `mm_lti_provider` WHERE id = ? ";
		List lti = getJdbcTemplate().query(sql, new Object[] { Long.valueOf(id) }, new LtiProviderRowMapper());
		if (lti == null) {
			return null;
		}
		if (lti.size() < 1) {
			return null;
		} else {
			return (LtiProvider) lti.get(0);
		}

	}

	@Override
	@SuppressWarnings("unchecked")
	public LtiProvider getLtiProvider(String url) {
		String sql = "SELECT * FROM `mm_lti_provider` WHERE returnUrl = ? ";
		List lti = getJdbcTemplate().query(sql, new Object[] { url }, new LtiProviderRowMapper());
		if (lti == null) {
			return null;
		}
		if (lti.size() < 1) {
			return null;
		} else {
			return (LtiProvider) lti.get(0);
		}
	}

}
