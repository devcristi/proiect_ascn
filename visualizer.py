import tkinter as tk
from tkinter import messagebox
import subprocess
import os

class SevenSegVisualizer:
    def __init__(self, root):
        self.root = root
        self.root.title("ASCN - 7 Segment Visualizer")
        self.root.geometry("300x500")

        # Input section
        tk.Label(root, text="Introduceti valoare (0-9):", font=("Arial", 12)).pack(pady=10)
        self.entry = tk.Entry(root, font=("Arial", 14), width=10)
        self.entry.pack()
        self.entry.bind("<Return>", lambda e: self.update_display())
        
        tk.Button(root, text="Actualizeaza Afisaj", command=self.update_display, bg="#4CAF50", fg="white").pack(pady=10)

        # Canvas for drawing segments
        self.canvas = tk.Canvas(root, width=250, height=350, bg="black")
        self.canvas.pack(pady=20)

        # Segment coordinates (x1, y1, x2, y2)
        # a: top, b: top-right, c: bottom-right, d: bottom, e: bottom-left, f: top-left, g: middle
        self.segments = {
            'a': [50, 30, 150, 40],
            'b': [150, 40, 160, 140],
            'c': [150, 160, 160, 260],
            'd': [50, 260, 150, 270],
            'e': [40, 160, 50, 260],
            'f': [40, 40, 50, 140],
            'g': [50, 145, 150, 155]
        }
        self.seg_ids = {}
        for seg, coords in self.segments.items():
            self.seg_ids[seg] = self.canvas.create_rectangle(*coords, fill="#330000", outline="")

        self.status_label = tk.Label(root, text="Status: Asteptare", fg="blue")
        self.status_label.pack()

    def get_verilog_output(self, val):
        try:
            # Compile
            subprocess.run(["wsl", "iverilog", "-o", "sim_simple", "bcd_to_7seg.v", "tb_simple.v"], check=True)
            # Run with plusarg
            result = subprocess.run(["wsl", "vvp", "sim_simple", f"+input={val}"], capture_output=True, text=True, check=True)
            
            # Extragem doar prima linie (cea cu 0 si 1)
            lines = result.stdout.strip().split('\n')
            if lines:
                return lines[0].strip()
            return None
        except Exception as e:
            messagebox.showerror("Eroare", f"Eroare la rularea Verilog: {e}")
            return None

    def update_display(self):
        val_str = self.entry.get()
        try:
            val = int(val_str)
            if not (0 <= val <= 9):
                raise ValueError
        except ValueError:
            messagebox.showwarning("Atentie", "Introduceti un numar intre 0 si 9!")
            return

        seg_bits = self.get_verilog_output(val)
        if seg_bits and len(seg_bits) == 7:
            # seg_bits is abcdefg
            colors = ["red" if b == '1' else "#330000" for b in seg_bits]
            seg_order = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
            
            for i, seg_name in enumerate(seg_order):
                self.canvas.itemconfig(self.seg_ids[seg_name], fill=colors[i])
            
            if val > 9:
                self.status_label.config(text=f"Status: EXCEPTIE (Valoare {val})", fg="orange")
            else:
                self.status_label.config(text=f"Status: OK (Cifra {val})", fg="green")
        else:
            self.status_label.config(text="Status: Eroare simulare", fg="red")

if __name__ == "__main__":
    root = tk.Tk()
    app = SevenSegVisualizer(root)
    root.mainloop()
