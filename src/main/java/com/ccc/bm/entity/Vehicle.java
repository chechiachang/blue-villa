/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ccc.bm.entity;

/**
 *
 * @author davidchang
 */
public class Vehicle {

    private String id;
    private boolean disabled;
    private int classId;
    private String name;
    private String sortKey;
    private String description;
    private int capacity;
    private String objectAdminEmail;
    private String customHtml;
    private String color;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isDisabled() {
        return disabled;
    }

    public void setDisabled(boolean disabled) {
        this.disabled = disabled;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSortKey() {
        return sortKey;
    }

    public void setSortKey(String sortKey) {
        this.sortKey = sortKey;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getObjectAdminEmail() {
        return objectAdminEmail;
    }

    public void setObjectAdminEmail(String objectAdminEmail) {
        this.objectAdminEmail = objectAdminEmail;
    }

    public String getCustomHtml() {
        return customHtml;
    }

    public void setCustomHtml(String customHtml) {
        this.customHtml = customHtml;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

}
