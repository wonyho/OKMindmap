package com.okmindmap.dao.mysql.spring.mapper;

import com.okmindmap.model.Token;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

// Referenced classes of package com.okmindmap.dao.mysql.spring.mapper:
//            RowMapperBase

public class TokenRowMapper extends RowMapperBase
    implements RowMapper
{

    public TokenRowMapper()
    {
    }

    public Object mapRow(ResultSet rs, int arg1)
        throws SQLException
    {
        Token tk = new Token();
        tk.setId(rs.getLong("id"));
        tk.setUser(rs.getLong("user"));
        tk.setValue(rs.getString("value"));
        tk.setCreated(rs.getLong("created"));
        return tk;
    }
}
