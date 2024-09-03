package com.okmindmap.service.impl;

import java.util.List;

import com.okmindmap.dao.IotDAO;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotModules;
import com.okmindmap.model.iot.IotSensor;
import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.service.IotService;

public class IotServiceImpl implements IotService {

	private IotDAO iotDAO;
	public void setIotDAO(IotDAO iotDAO) {
		this.iotDAO = iotDAO;
	}

	public List<IotSensor> getSensorList(){
		return this.iotDAO.getSensorList();
	}

	public List<IotModules> getModuleList(){
		return this.iotDAO.getModuleList();
	}
	
	public List<IotDevices> getDevices(int userId){
		return this.iotDAO.getDevices(userId);
	}
	
	public IotDevices getDevice(String key) {
		return this.iotDAO.getDevice(key);
	}
	
	public IotDevices getDevice(int userId, String key) {
		return this.iotDAO.getDevice(userId, key);
	}
	
	public List<IotConnection> getDeviceConnection(int userId, int deviceId){
		return this.iotDAO.getDeviceConnection(userId, deviceId);
	}
	
	public boolean setConnectionAction(int connId, String actionString) {
		return this.iotDAO.setConnectionAction(connId, actionString);
	}
	
	public String getConnectionAction(int connId) {
		return this.iotDAO.getConnectionAction(connId);
	}
	
	public boolean setConnectValue(int connId, String valueString) {
		return this.iotDAO.setConnectValue(connId, valueString);
	}
	
	public String getConnectValue(int connId) {
		return this.iotDAO.getConnectValue(connId);
	}
	
	public boolean setConnectStatus(int connId, String valueString) {
		return this.iotDAO.setConnectStatus(connId, valueString);
	}
	
	public String getConnectStatus(int connId) {
		return this.iotDAO.getConnectStatus(connId);
	}
	
	public boolean addDevices(IotDevices device) {
		return this.iotDAO.addDevices(device);
	}
	
	public boolean editDevice(int id, String name) {
		return this.iotDAO.editDevice(id, name);
	}
	
	public boolean deleteDevice(int id) {
		return this.iotDAO.deleteDevice(id);
	}
	
	public boolean addSensorConnection(IotConnection conn) {
		return this.iotDAO.addSensorConnection(conn);
	}
	
	public boolean editSensorConnection(int id, String name, String note, String layout, String layoutW, String layoutH) {
		return this.iotDAO.editSensorConnection(id, name, note, layout, layoutW, layoutH);
	}
	
	public boolean deleteSensorConnection(int id) {
		return this.iotDAO.deleteSensorConnection(id);
	}

	public double getLastTimeConnected(int connId) {
		return this.iotDAO.getLastTimeConnected(connId);
	}
	
	public IotDevices getDevice(int userId, int deviceId) {
		return this.iotDAO.getDevice(userId, deviceId);
	}
	
	public IotConnection getConnection(int userId, int deviceId) {
		return this.iotDAO.getConnection(userId, deviceId);
	}
	
	public RedFlow getFlow(String username, String mac ) {
		return this.iotDAO.getFlow(username, mac);
	}
	
	public List<RedFlow> getFlows(int userId){
		return this.iotDAO.getFlows(userId);
	}
	
	public List<RedFlow> getFlows(String username){
		return this.iotDAO.getFlows(username);
	}
	
	public boolean addFlow(RedFlow rf) {
		return this.iotDAO.addFlow(rf);
	}
	
	public boolean updateConnectedFlow(RedFlow rf) {
		return this.iotDAO.updateConnectedFlow(rf);
	}
}
