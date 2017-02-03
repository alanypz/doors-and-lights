using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media;
using FirstFloor.ModernUI.Windows.Controls;
using FirstFloor.ModernUI.Presentation;

namespace City_Of_Orlando_Automated_Controller
{
    public static class Utility
    {
        public static User user = null;
        public static Component[] components = null;
        public static int componentIndex = 0;
        public static Button[] componentButtons = null;
        public static ImageBrush doorBrush = null;
        public static ImageBrush lightBrush = null;
        public static object[] lrDoors = null;
        public static object[] lrLights = null;
        public static string title { get; set; }
        public static int fail { get; set; }
        public static int stop { get; set; }
        public static bool autoRefresh { get; set; }
        public static BackgroundWorker refreshWorker { get; set; }
        public static MainWindow window { get; set; }
        public static Link link1 { get; set; }
        public static Link link2 { get; set; }
        public static string ip = "http://localhost:8080";
        //public static string ip = "http://10.0.0.2:8080";
        //public static string ip = "http://Alans-MacBook-Pro.local";
        //public static string ip = "http://192.168.43.12:8080";
        //public static string ip = "http://192.168.1.2:8080";
        //public static string ip = "http://192.168.137.133:8080";
    }
}
