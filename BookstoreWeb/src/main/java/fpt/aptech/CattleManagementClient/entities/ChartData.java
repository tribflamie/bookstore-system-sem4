/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fpt.aptech.CattleManagementClient.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 *
 * @author AnhLinh
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChartData {
   private String period;
    private int order;
    private double profit;
    private int quantity;
}
