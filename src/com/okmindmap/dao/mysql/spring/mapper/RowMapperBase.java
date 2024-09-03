package com.okmindmap.dao.mysql.spring.mapper;

import java.io.IOException;
import java.io.Reader;
import java.sql.Clob;
import java.sql.SQLException;

public class RowMapperBase {
	/**
	 * 
	 * @param clob
	 * @return
	 * @throws SQLException
	 * @throws IOException
	 */
	public String getString(Clob clob) throws SQLException, IOException {
		if(clob == null) {
			return null;
		}
		
		StringBuffer stringBuffer = new StringBuffer();
		Reader reader = clob.getCharacterStream();
		char[] buffer = new char[1024];
		int readed = 0;
		while( (readed = reader.read(buffer, 0, buffer.length)) > 0) {
			stringBuffer.append(new String(buffer, 0, readed));
		}
		reader.close();
		
		return stringBuffer.toString();
	}
}
