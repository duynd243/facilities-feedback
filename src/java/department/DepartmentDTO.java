/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package department;

import java.util.Objects;

/**
 *
 * @author Duy
 */
public class DepartmentDTO {

    private int depID;
    private String depName;

    public DepartmentDTO() {
    }

    public DepartmentDTO(int depID, String depName) {
        this.depID = depID;
        this.depName = depName;
    }

    public int getDepID() {
        return depID;
    }

    public void setDepID(int depID) {
        this.depID = depID;
    }

    public String getDepName() {
        return depName;
    }

    public void setDepName(String depName) {
        this.depName = depName;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof DepartmentDTO) {
            DepartmentDTO d = (DepartmentDTO) obj;
            if (this.depID == d.depID && this.depName.equals(d.depName)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 17 * hash + this.depID;
        hash = 17 * hash + Objects.hashCode(this.depName);
        return hash;
    }

    @Override
    public String toString() {
        return "DepartmentDTO{" + "depID=" + depID + ", depName=" + depName + '}';
    }

}
