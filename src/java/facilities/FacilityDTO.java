/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facilities;

/**
 *
 * @author USER
 */
public class FacilityDTO {

    String facilityID;
    String facilityName;

    public FacilityDTO() {
    }

    public FacilityDTO(String facilityID, String facilityName) {
        this.facilityID = facilityID;
        this.facilityName = facilityName;
    }

    public String getFacilityID() {
        return facilityID;
    }

    public void setFacilityID(String facilityID) {
        this.facilityID = facilityID;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }

}
