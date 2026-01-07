`timescale 1ns/1ps

module tb_display_system;

    reg  [3:0] user_input;
    wire [6:0] segments;
    wire       is_valid;

    // Instantiem decodificatorul
    bcd_to_7seg uut (
        .bcd(user_input),
        .seg(segments),
        .valid(is_valid)
    );

    // Task pentru a simula introducerea unei cifre de catre utilizator
    task enter_digit(input [3:0] val);
        begin
            user_input = val;
            #10; // Asteptam 10 unitati de timp
            if (is_valid) begin
                $display("[USER] Intrare: %0d | STATUS: OK | Segmente: %b", user_input, segments);
            end else begin
                $display("[USER] Intrare: %0d | STATUS: EROARE (Cifra invalida!) | Segmente: %b", user_input, segments);
            end
        end
    endtask

    integer status;
    integer val_citita;

    // Task pentru afisare grafica ASCII
    task print_7seg_graphic(input [6:0] s);
        reg a,b,c,d,e,f,g;
        begin
            a = s[6]; b = s[5]; c = s[4]; d = s[3]; e = s[2]; f = s[1]; g = s[0];
            $display("  %s  ", a ? "---" : "   ");
            $display("%s     %s", f ? "|" : " ", b ? "|" : " ");
            $display("%s     %s", f ? "|" : " ", b ? "|" : " ");
            $display("  %s  ", g ? "---" : "   ");
            $display("%s     %s", e ? "|" : " ", c ? "|" : " ");
            $display("%s     %s", e ? "|" : " ", c ? "|" : " ");
            $display("  %s  ", d ? "---" : "   ");
        end
    endtask

    initial begin
        $display("--- Sistem de Afisaj Interactiv (Grafic) ---");
        $display("Introduceti o cifra (0-15) si apasati Enter.");
        $display("Pentru a opri, introduceti un numar negativ.");
        
        while (1) begin
            $write("\nIntroduceti valoare: ");
            status = $fscanf(32'h8000_0000, "%d", val_citita);
            
            if (val_citita < 0) begin
                $display("Simulare oprita.");
                $finish;
            end
            
            user_input = val_citita[3:0];
            #1; 
            
            if (is_valid) begin
                $display(">> REZULTAT: Cifra %0d", user_input);
                print_7seg_graphic(segments);
            end else begin
                $display(">> ALERTA: Valoarea %0d este INVALIDA!", val_citita);
                print_7seg_graphic(segments);
            end
        end
    end

endmodule
