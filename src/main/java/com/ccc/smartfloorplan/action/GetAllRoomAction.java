/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.smartfloorplan.action;

import com.ccc.smartfloorplan.entity.JdbcConn;
import com.ccc.smartfloorplan.entity.Room;
import com.ccc.util.XmlMapping;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author davidchang
 */
public class GetAllRoomAction extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs;
            try {
                XmlMapping xmlConfig = new XmlMapping(new File(getServletConfig().getServletContext().getRealPath("/WEB-INF/config.xml")));
                Class.forName(xmlConfig.LookupKey("DRIVER_MANAGER"));
                conn = DriverManager.getConnection(xmlConfig.LookupKey("DB_URL"), xmlConfig.LookupKey("USER"), xmlConfig.LookupKey("PASS"));
                
                pstmt = conn.prepareStatement("SELECT `id`, `roomId`, `name`, `floorId`, `text`, `imageUri`, `color`, `fontSize`, `left`, `top`, "
                        + "`width`, `height`, `footpath` FROM `rooms` ORDER BY `id` ASC");
                rs = pstmt.executeQuery();
                List<Room> rooms = new ArrayList<>();
                while (rs.next()) {
                    Room room = new Room();
                    room.setId(rs.getInt("id"));
                    room.setRoomId(rs.getInt("roomId"));
                    room.setName(rs.getString("name"));
                    room.setFloorId(rs.getInt("floorId"));
                    room.setText(rs.getString("text"));
                    room.setImageUri(rs.getString("imageUri"));
                    room.setColor(rs.getString("color"));
                    room.setFontSize(rs.getString("fontSize"));
                    room.setLeft(rs.getInt("left"));
                    room.setTop(rs.getInt("top"));
                    room.setWidth(rs.getInt("width"));
                    room.setHeight(rs.getInt("height"));
                    room.setFootpath(rs.getString("footpath"));
                    rooms.add(room);
                }
                HttpSession session = request.getSession();
                session.setAttribute("rooms", rooms);
                session.setMaxInactiveInterval(5 * 60);

            } catch (ClassNotFoundException ex) {
                Logger.getLogger(GetAllFloorAction.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(GetAllFloorAction.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                out.close();
                try {
                    if (pstmt != null) {
                        pstmt.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try {
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
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
