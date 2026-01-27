# Garmin Watch Face: [Retro-Simple](https://apps.garmin.com/apps/7836e8cf-f3df-4711-a1ee-6b68513e7d3e) 


<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/ded59a33-1a1e-47a3-b950-49b38d6898b5" width="300"/></td>
    <td> A simplistic watch face in retro style. Inspired by old Casio watches. 5 customizable fields. 64 colours to choose from. </td>
  </tr>
</table>

---
<img src="https://github.com/user-attachments/assets/80567836-f437-4e87-bb3d-519967e31025" width="900"/>

<img src="https://github.com/user-attachments/assets/62a30191-be2f-4fd4-a4c9-7889bad82fc8" width="900"/>

<img src="https://github.com/user-attachments/assets/38da0453-97a0-47b6-acde-3e46e35a23ec" width="900"/>

## Set-up
### Installations

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/) - follow the steps in the link for your operating system
- *VS Code* or *Curser* with the *Monkey C Extension*
- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-downloads.html)



### Build & Run
---
* Set-up variables

    Fill in your set-up variables in `properties.mk`

* Build with debug logs
   ```sh
   make build
   ```
* Run on simulator
   ```sh
   make run.settings
   ```
* Deploy on device
    1. Enable *Developer Mode* on your Garmin watch. 
    2. Copy the compiled `.prg` file from the `bin` into the `/GARMIN/APPS/` directory on your watch. (For Mac I used [Android File Transfer](https://android.p2hp.com/filetransfer/index.html))


If you want to test the settings on your comupter you can go in the Simulator either
* Trigger App Settings & click on the buttons in the simulator
or
* File > Edit Persistent Storage > Edit Application.Properties data


---

Contributions are more than welcome, if you give me time to test them, I might release it and publish to Connect IQ.

---

#### License
This project is licensed under GPLv3+
