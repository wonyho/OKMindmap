package com.okmindmap.dao.mysql.spring;

import java.util.List;

import com.okmindmap.dao.IotDAO;
import com.okmindmap.dao.mysql.spring.mapper.iot.IotConnectionMapper;
import com.okmindmap.dao.mysql.spring.mapper.iot.IotDeviceMapper;
import com.okmindmap.dao.mysql.spring.mapper.iot.IotModuleMapper;
import com.okmindmap.dao.mysql.spring.mapper.iot.IotSensorMapper;
import com.okmindmap.dao.mysql.spring.mapper.iot.RedFlowMapper;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotModules;
import com.okmindmap.model.iot.IotSensor;
import com.okmindmap.model.iot.RedFlow;

public class SpringIotDAO  extends SpringDAOBase implements IotDAO  {

	@SuppressWarnings("unchecked")
	@Override
	public List<IotSensor> getSensorList(){
		String sql = "SELECT * FROM `mm_iot_sensor`";
		return getJdbcTemplate().query(sql, new Object[] {}, new IotSensorMapper());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<IotModules> getModuleList(){
		String sql = "SELECT * FROM `mm_iot_modules`";
		return getJdbcTemplate().query(sql, new Object[] {}, new IotModuleMapper());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<IotDevices> getDevices(int userId){
		String sql = "SELECT * "
				+ "FROM `mm_iot_devices` "
				+ "JOIN `mm_iot_modules` ON `mm_iot_modules`.`module_id` = `mm_iot_devices`.`dev_module` "
				+ "WHERE `mm_iot_devices`.`dev_user`=?";
		return getJdbcTemplate().query(sql, new Object[] {userId}, new IotDeviceMapper());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public IotDevices getDevice(String key) {
		String sql = "SELECT * "
				+ "FROM `mm_iot_devices` "
				+ "JOIN `mm_iot_modules` ON `mm_iot_modules`.`module_id` = `mm_iot_devices`.`dev_module` "
				+ "WHERE `mm_iot_devices`.`dev_secret`=?";
		List<IotDevices> list = getJdbcTemplate().query(sql, new Object[] {key}, new IotDeviceMapper());
		if(list == null) return null;
		if(list.size() == 0) return null;
		return list.get(0);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public IotDevices getDevice(int userId, String key) {
		String sql = "SELECT * "
				+ "FROM `mm_iot_devices` "
				+ "JOIN `mm_iot_modules` ON `mm_iot_modules`.`module_id` = `mm_iot_devices`.`dev_module` "
				+ "WHERE `mm_iot_devices`.`dev_user`=? AND `mm_iot_devices`.`dev_secret`=?";
		List<IotDevices> list = getJdbcTemplate().query(sql, new Object[] {userId, key}, new IotDeviceMapper());
		if(list == null) return null;
		if(list.size() == 0) return null;
		return list.get(0);
	}
	@SuppressWarnings("unchecked")
	@Override
	public IotDevices getDevice(int userId, int deviceId) {
		String sql = "SELECT * "
				+ "FROM `mm_iot_devices` "
				+ "JOIN `mm_iot_modules` ON `mm_iot_modules`.`module_id` = `mm_iot_devices`.`dev_module` "
				+ "WHERE `mm_iot_devices`.`dev_user`=? AND `mm_iot_devices`.`dev_id`=?";
		List<IotDevices> list = getJdbcTemplate().query(sql, new Object[] {userId, deviceId}, new IotDeviceMapper());
		if(list == null) return null;
		if(list.size() == 0) return null;
		return list.get(0);
	}
	@SuppressWarnings("unchecked")
	@Override
	public IotConnection getConnection(int userId, int deviceId) {
		String sql = "SELECT * "
				+ "FROM `mm_iot_conection` "
				+ "JOIN `mm_iot_devices` ON `mm_iot_devices`.`dev_id` = `mm_iot_conection`.`id_device` "
				+ "AND `mm_iot_conection`.`id` = ? "
				+ "JOIN `mm_iot_sensor` ON `mm_iot_sensor`.`sensor_id` = `mm_iot_conection`.`id_sensor` "
				+ "WHERE `mm_iot_devices`.`dev_user` = ?";
		List<IotConnection> l =  getJdbcTemplate().query(sql, new Object[] {deviceId, userId}, new IotConnectionMapper());
		if(l == null) return new IotConnection();
		if(l.size() < 1) return new IotConnection();
		return l.get(0);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<IotConnection> getDeviceConnection(int userId, int deviceId){
		String sql = "SELECT * "
				+ "FROM `mm_iot_conection` "
				+ "JOIN `mm_iot_devices` ON `mm_iot_devices`.`dev_id` = `mm_iot_conection`.`id_device` "
				+ "AND `mm_iot_devices`.`dev_id` = ? "
				+ "JOIN `mm_iot_sensor` ON `mm_iot_sensor`.`sensor_id` = `mm_iot_conection`.`id_sensor` "
				+ "WHERE `mm_iot_devices`.`dev_user` = ?";
		return getJdbcTemplate().query(sql, new Object[] {deviceId, userId}, new IotConnectionMapper());
	}
	
	public boolean setConnectionAction(int connId, String actionString) {
		String sql = "UPDATE `mm_iot_conection` SET `actions`=? WHERE `id`=?";
		int result = getJdbcTemplate().update(sql,new Object[]{actionString, connId});
		return result > 0;
	}
	
	public String getConnectionAction(int connId) {
		String sql = "SELECT `mm_iot_conection`.`actions` "
				+ "FROM `mm_iot_conection` "
				+ "JOIN `mm_iot_devices` ON `mm_iot_devices`.`dev_id` = `mm_iot_conection`.`id_device` "
				+ "WHERE `mm_iot_conection`.`id` = ?";
		String value = (String) getJdbcTemplate().queryForObject(sql,new Object[]{connId}, String.class);
		return value;
	}
	
	public boolean setConnectValue(int connId, String valueString) {
		String sql = "UPDATE `mm_iot_conection` SET `value`=?, `last_update`=? WHERE `id`=?";
		int result = getJdbcTemplate().update(sql,new Object[]{valueString,System.currentTimeMillis(), connId});
		return result > 0;
	}
	
	public String getConnectValue(int connId) {
		String sql = "SELECT `mm_iot_conection`.`value` "
				+ "FROM `mm_iot_conection` "
				+ "JOIN `mm_iot_devices` ON `mm_iot_devices`.`dev_id` = `mm_iot_conection`.`id_device` "
				+ "WHERE `mm_iot_conection`.`id` = ?";
		String value = (String) getJdbcTemplate().queryForObject(sql,new Object[]{connId}, String.class);
		return value;
	}
	
	public boolean setConnectStatus(int connId, String valueString) {
		String sql = "UPDATE `mm_iot_conection` SET `status`=? WHERE `id`=?";
		int result = getJdbcTemplate().update(sql,new Object[]{valueString, connId});
		return result > 0;
	}
	
	public String getConnectStatus(int connId) {
		String sql = "SELECT `mm_iot_conection`.`status` "
				+ "FROM `mm_iot_conection` "
				+ "JOIN `mm_iot_devices` ON `mm_iot_devices`.`dev_id` = `mm_iot_conection`.`id_device` "
				+ "WHERE `mm_iot_conection`.`id` = ?";
		String value = (String) getJdbcTemplate().queryForObject(sql,new Object[]{connId}, String.class);
		return value;
	}
	
	public boolean addDevices(IotDevices device) {
		
		String sql = "INSERT INTO `mm_iot_devices`(`dev_id`, `dev_module`, `dev_user`, `dev_name`, `dev_secret`, `dev_created`) "
				+ "VALUES (null, ?, ?, ?, ?, ?)";
		int result = getJdbcTemplate().update(sql,new Object[]{
				device.getModules().getId(),
				device.getUserId(),
				device.getName(),
				device.getSecret(),
				System.currentTimeMillis()
		});
		return result > 0;
		
	}
	
	public boolean editDevice(int id, String name) {
		String sql = "UPDATE `mm_iot_devices` SET `dev_name`= ? WHERE `dev_id`= ? ";
		int result = getJdbcTemplate().update(sql,new Object[]{
				name, id
		});
		return result > 0;
	}
	
	public boolean deleteDevice(int id) {
		String sql = "DELETE FROM `mm_iot_conection` WHERE `id_device`= ? ";
		int result = getJdbcTemplate().update(sql,new Object[]{
				id
		});
		
		sql = "DELETE FROM `mm_iot_devices` WHERE `dev_id`= ? ";
		result = getJdbcTemplate().update(sql,new Object[]{
				id
		});
		return result > 0;
	}
	
	public boolean addSensorConnection(IotConnection conn) {
		String sql = "INSERT INTO `mm_iot_conection`(`id`, `id_device`, `id_sensor`, `name`, `note`, `created`, "
				+ "`status`, `actions`, `value`, `last_update`, `layout`, `layout_w`, `layout_h`)  "
				+ "VALUES (null, ?, ?, ?, ?, ? ,? ,? ,? ,?, ?, ?, ?)";
		int result = getJdbcTemplate().update(sql,new Object[]{
				conn.getDevice().getId(),
				conn.getSensor().getId(),
				conn.getName(),
				conn.getNote(),
				System.currentTimeMillis(),
				0,0,0,System.currentTimeMillis(),
				conn.getLayout(),
				conn.getLayoutWidth(),
				conn.getLayoutHeight()
		});
		return result > 0;
	}
	
	public boolean editSensorConnection(int id, String name, String note, String layout, String layoutW, String layoutH) {
		String sql = "UPDATE `mm_iot_conection` SET `name`= ?,`note`= ?, `layout` = ?, `layout_w`=?, `layout_h`=? WHERE `id`= ? ";
		int result = getJdbcTemplate().update(sql,new Object[]{
				name, note, layout, layoutW, layoutH, id
		});
		return result > 0;
	}
	
	public boolean deleteSensorConnection(int id) {
		String sql = "DELETE FROM `mm_iot_conection` WHERE `id`= ? ";
		int result = getJdbcTemplate().update(sql,new Object[]{
				id
		});
		return result > 0;
	}
	
	public double getLastTimeConnected(int connId) {
		String sql = "SELECT `mm_iot_conection`.`last_update` "
				+ "FROM `mm_iot_conection` "
				+ "JOIN `mm_iot_devices` ON `mm_iot_devices`.`dev_id` = `mm_iot_conection`.`id_device` "
				+ "WHERE `mm_iot_conection`.`id` = ?";
		double value = (Double) getJdbcTemplate().queryForObject(sql,new Object[]{connId}, Double.class);
		return value;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public RedFlow getFlow(String flowId){
		String sql = "SELECT * FROM `mm_red_flows` WHERE flow_id = ? ";
		List<RedFlow> list = getJdbcTemplate().query(sql, new Object[] {flowId}, new RedFlowMapper());
		if(list == null) return null;
		if(list.size() < 1) return null;
		return list.get(0);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public RedFlow getFlow(String username, String mac ) {
		String sql = "SELECT * FROM `mm_red_flows` WHERE username = ? AND connected = ? ";
		List<RedFlow> list = getJdbcTemplate().query(sql, new Object[] {username, mac}, new RedFlowMapper());
		if(list == null) return null;
		if(list.size() < 1) return null;
		return list.get(0);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<RedFlow> getFlows(int userId){
		String sql = "SELECT * FROM `mm_red_flows` WHERE user_id = ? ";
		return getJdbcTemplate().query(sql, new Object[] {userId}, new RedFlowMapper());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<RedFlow> getFlows(String username){
		String sql = "SELECT * FROM `mm_red_flows` WHERE username = ? ";
		return getJdbcTemplate().query(sql, new Object[] {username}, new RedFlowMapper());
	}
	
	public boolean addFlow(RedFlow rf) {
		
		long time = System.currentTimeMillis();
		if(this.getFlow(rf.getFlowId()) == null) {
			String sql = "INSERT INTO `mm_red_flows`(`id`, `username`, `user_id`, `flow_id`, `flow_name`, `created`, `edited`) "
					+ "VALUES (null, ?, ?, ?, ?, ?, ?)";
			int result = getJdbcTemplate().update(sql,new Object[]{
					rf.getUsername(),
					rf.getUserId(),
					rf.getFlowId(),
					rf.getFlowName(),
					time,
					time
			});
			return result > 0;
			
		}else {
			String sql = "UPDATE `mm_red_flows` SET `username` =?, `user_id`=?, `flow_name`=?,`edited`=? "
					+ " WHERE `flow_id`=? ";
			int result = getJdbcTemplate().update(sql,new Object[]{
					rf.getUsername(),
					rf.getUserId(),
					rf.getFlowName(),
					time,
					rf.getFlowId()
			});
			return result > 0;
		}
	}
	
	public boolean updateConnectedFlow(RedFlow rf) {
		String sql = "UPDATE `mm_red_flows` SET `connected`=? "
				+ " WHERE `flow_id`=? AND `username` =? ";
		int result = getJdbcTemplate().update(sql,new Object[]{
				rf.getMacAddress(),
				rf.getFlowId(), 
				rf.getUsername()
		});
		return result > 0;
	}
}
