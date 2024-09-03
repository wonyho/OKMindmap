package com.okmindmap.model;


public class Token
{

    private long id;
    private long user;
    private String value;
    private long created;

    public Token()
    {
        id = 0L;
        user = 0L;
        value = "";
        created = 0L;
    }

    public long getId()
    {
        return id;
    }

    public void setId(long id)
    {
        this.id = id;
    }

    public long getUser()
    {
        return user;
    }

    public void setUser(long user)
    {
        this.user = user;
    }

    public String getValue()
    {
        return value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }

    public long getCreated()
    {
        return created;
    }

    public void setCreated(long created)
    {
        this.created = created;
    }
}