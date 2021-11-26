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
    private String hd;
    private int depID;
    private int statusID;
    private float rate;

    public GoogleUserDTO() {
    }

    public GoogleUserDTO(String email, String name, String picture, int statusID) {
        this.email = email;
        this.name = name;
        this.picture = picture;
        this.statusID = statusID;
    }

    public GoogleUserDTO(String email, String name, String picture, int depID, float rate) {
        this.email = email;
        this.name = name;
        this.picture = picture;
        this.depID = depID;
        this.rate = rate;
    }

    public GoogleUserDTO(String email, String name, String picture, String roleID, String hd) {
        this.email = email;
        this.name = name;
        this.picture = picture;
        this.roleID = roleID;
        this.hd = hd;
    }

    public GoogleUserDTO(String email, String name, String picture, String roleID, int depID) {
        this.email = email;
        this.name = name;
        this.picture = picture;
        this.roleID = roleID;
        this.depID = depID;
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

    public int getDepID() {
        return depID;
    }

    public void setDepID(int depID) {
        this.depID = depID;
    }

    public float getRate() {
        return rate;
    }

    public void setRate(float rate) {
        this.rate = rate;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    @Override
    public String toString() {
        return "GoogleUserDTO{" + "email=" + email + ", name=" + name + ", picture=" + picture + ", roleID=" + roleID + ", hd=" + hd + ", depID=" + depID + ", statusID=" + statusID + ", rate=" + rate + '}';
    }
}