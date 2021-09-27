/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package googleuser;

/**
 *
 * @author Duy
 */
public class GoogleUserDTO {
    private String email;
    private String name;
    private String picture;
    private String roleID;
    private String hd; // với các email có custom domain (không phải @gmail.com), json trả về sẽ có field hd chứa custom domain (ví dụ hd="fpt.edu.vn")

    public GoogleUserDTO() {
    }

    public GoogleUserDTO(String email, String name, String picture, String roleID, String hd) {
        this.email = email;
        this.name = name;
        this.picture = picture;
        this.roleID = roleID;
        this.hd = hd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getRoleID() {
        return roleID;
    }

    public void setRoleID(String roleID) {
        this.roleID = roleID;
    }

    public String getHd() {
        return hd;
    }

    public void setHd(String hd) {
        this.hd = hd;
    }

    @Override
    public String toString() {
        return "GoogleUserDTO{" + "email=" + email + ", name=" + name + ", picture=" + picture + ", roleID=" + roleID + ", hd=" + hd + '}';
    }
    
    
}
