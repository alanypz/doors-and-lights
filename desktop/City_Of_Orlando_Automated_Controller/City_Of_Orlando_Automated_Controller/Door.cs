using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace City_Of_Orlando_Automated_Controller
{
    class Component
    {

        public Component()
        {
            //Default Constructor
        }

        public Component(int id, int garage, int bay, string status, string lastActionTime, string lastAction)
        {
            this.id = id;
            this.garage = garage;
            this.bay = bay;
            this.status = status;
            this.lastActionTime = lastAction;
            this.lastAction = lastAction;
        }

        public int id { get; set; }
        public int garage { get; set; }
        public int bay { get; set; }
        public string status { get; set; }
        public string lastActionTime { get; set; }
        public string lastAction { get; set; }

    }
}
