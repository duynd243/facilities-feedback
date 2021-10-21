/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package department;

import java.util.ArrayList;
import java.util.HashMap;

import googleuser.GoogleUserDTO;
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

    public boolean equals(DepartmentDTO d){
        if(this.depID == d.depID && this.depName.equals(d.depName))
            return true;
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
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final DepartmentDTO other = (DepartmentDTO) obj;
        return true;
    }

    @Override
    public String toString() {
        return "DepartmentDTO{" + "depID=" + depID + ", depName=" + depName + '}';
    }
    
    public static void main(String[] args){
        DepartmentDAO dao = new DepartmentDAO();
        DepartmentDTO dep = new DepartmentDTO(1, "Electric");
        DepartmentDTO dep2 = new DepartmentDTO(1, "Electric");

        GoogleUserDTO user = new GoogleUserDTO("duy", "duy", "duy", "duy", 1);
        GoogleUserDTO user2 = new GoogleUserDTO("duy2", "duy", "duy", "duy", 1);
        HashMap<DepartmentDTO, ArrayList<GoogleUserDTO>> hm = new HashMap<>();
        
        ArrayList<GoogleUserDTO> list = new ArrayList<>();
        
        if(hm.containsKey(dep)){
            hm.get(dep).add(user);
        } else{
            list.add(user);
            hm.put(dep,list);
        }


        System.out.println(hm.containsKey(dep2));
    }
}
