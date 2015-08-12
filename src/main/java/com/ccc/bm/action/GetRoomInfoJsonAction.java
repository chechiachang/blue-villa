/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.action;

import com.google.gson.Gson;
import com.ccc.bm.entity.JdbcConn;
import com.ccc.bm.entity.Room;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author davidchang
 */
@WebServlet(name = "GetRoomInfoJsonAction", urlPatterns = "{/GetRoomInfoJsonAction}")
public class GetRoomInfoJsonAction extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String roomId = request.getParameter("roomId");
        try (PrintWriter out = response.getWriter()) {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs;
            try {
                Class.forName(JdbcConn.getDRIVER_MANAGER());
                conn = DriverManager.getConnection(JdbcConn.getDB_URL(), JdbcConn.getUSER(), JdbcConn.getPASS());
                ps = conn.prepareStatement("SELECT `id`, `name`, `class_id`, `text`, `uri`,`color`, `fontSize`, `top`, `left`, `height`, `width`, `footpath` FROM `rooms` WHERE `roomId` = ? ");
                ps.setString(1, roomId);
                rs = ps.executeQuery();
                List list = new ArrayList<>();
                while(rs.next()){
                    Room room = new Room();
                    room.setId(rs.getInt("id"));
                    room.setRoomId(Integer.valueOf(roomId));
                    room.setName(rs.getString("name"));
                    room.setClass_id(rs.getInt("class_id"));
                    room.setText(rs.getString("text"));
                    room.setUri(rs.getString("uri"));
                    room.setColor(rs.getString("color"));
                    room.setFontSize(rs.getString("fontSize"));
                    room.setTop(rs.getInt("top"));
                    room.setLeft(rs.getInt("left"));
                    room.setHeight(rs.getInt("height"));
                    room.setWidth(rs.getInt("width"));
                    room.setFootpath(rs.getString("footpath"));
                    list.add(room);
                }
                rs.close();
                String json = new Gson().toJson(list);
                response.setContentType("application/json");
                response.setContentType("text/html;charset=UTF-8");
                out.write(json);
                
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
