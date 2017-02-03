using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace City_Of_Orlando_Automated_Controller
{
    public class Component
    {

        public Component()
        {
            //Default Constructor
        }

        public Component(string _id,int number, string state, string position)
        {
            this._id = _id;
            this.number = number;
            this.state = state;
            this.position = position;
        }

        public string _id { get; set; }
        public int number { get; set; }
        public string state { get; set; }
        public string position { get; set; }
        public string type { get; set; }

    }
}
