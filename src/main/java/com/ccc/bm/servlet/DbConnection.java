package com.ccc.bm.servlet;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author davidchang
 */
public class DbConnection {

    static final String DB_URL = "jdbc:mysql://localhost:3306/booking_manager?useUnicode=yes&characterEncoding=UTF-8";
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String USER = "booking";
    static final String PASS = "booking";

    private Connection conn;
    private PreparedStatement ps;
    private Statement st;
    private ResultSet rs;

    public DbConnection() throws ClassNotFoundException, SQLException {
        Class.forName(JDBC_DRIVER);
        conn = DriverManager.getConnection(DB_URL, USER, PASS);
    }

    public Connection getConn() {
        return conn;
    }

    public void setConn(Connection conn) {
        this.conn = conn;
    }

    public PreparedStatement getPs() {
        return ps;
    }

    public void setPs(PreparedStatement ps) {
        this.ps = ps;
    }

    public Statement getSt() {
        return st;
    }

    public void setSt(Statement st) {
        this.st = st;
    }

    public ResultSet getRs() {
        return rs;
    }

    public void setRs(ResultSet rs) {
        this.rs = rs;
    }

}
