using System;
using ChildLib;
using GrandChildLib;

namespace TopApp
{
    class Program
    {
        static void Main(string[] args)
        {

            Console.WriteLine("console.start");

            var grandChild = new GrandChild();
            grandChild.Call();

            var child = new Child();
            child.Call();

            Console.WriteLine("console.end");
        }
    }
}
