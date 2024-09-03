package com.okmindmap.dao;

import java.util.List;

import com.okmindmap.model.iot.RedFlow;
import com.okmindmap.model.iot.IotConnection;
import com.okmindmap.model.iot.IotDevices;
import com.okmindmap.model.iot.IotModules;
import com.okmindmap.model.iot.IotSensor;

public interface IotDAO {
	public List<IotSensor> getSensorList();
	
	public List<IotModules> getModuleList();
	
	public List<IotDevices> getDevices(int userId);
	
	public IotDevices getDevice(String key);
	
	public IotDevices getDevice(int userId, String key);
	
	public List<IotConnection> getDeviceConnection(int userId, int deviceId);
	
	public boolean setConnectionAction(int connId, String actionString);
	
	public String getConnectionAction(int connId);
	
	public boolean setConnectValue(int connId, String valueString);
	
	public String getConnectValue(int connId);
	
	public boolean setConnectStatus(int connId, String valueString);
	
	public String getConnectStatus(int connId);
	
	public boolean addDevices(IotDevices device);
	
	public boolean editDevice(int id, String name);
	
	public boolean deleteDevice(int id);
	
	public boolean addSensorConnection(IotConnection conn);
	
	public boolean editSensorConnection(int id, String name, String note, String layout, String layoutW, String layoutH);
	
	public boolean deleteSensorConnection(int id);
	
	public double getLastTimeConnected(int connId);
	
	public IotDevices getDevice(int userId, int deviceId);
	
	public IotConnection getConnection(int userId, int deviceId);
	
	public RedFlow getFlow(String flowId);
	
	public RedFlow getFlow(String username, String mac );
	
	public List<RedFlow> getFlows(int userId);
	
	public List<RedFlow> getFlows(String username);
	
	public boolean addFlow(RedFlow rf);
	
	public boolean updateConnectedFlow(RedFlow rf);
}
