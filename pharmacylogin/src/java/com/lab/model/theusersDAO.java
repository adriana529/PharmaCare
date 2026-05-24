/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.lab.model;


public class theusersDAO {
    
    private String fullName;
    private String username;
    private String password;
    private String email;
    
    
    //Constructor
    public theusersDAO() {
    }
    
    public theusersDAO (String fullname,String username, String password,String email) {
        this.fullName = fullname;
        this.username = username;
        this.password = password;
        this.email = email;
    }
    
    //Getter and Setter
    public String getFullName() {
            return fullName;
    }
    
    public void setFullName(String fullName){
        this.fullName = fullName;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email){
        this.email = email;
    }
    
}
